//
//  CoreDataController.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/9/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    let DEFAULT_STUDENT = "Default Student"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    // Fetched Results Controllers
    var allSubjectsFetchedResultsController: NSFetchedResultsController<Subject>?
    var studentSubjectsFetchedResultsController: NSFetchedResultsController<Subject>?
    var allUniversitiesFetchedResultsController: NSFetchedResultsController<University>?
    
    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "Academica")
        persistentContainer.loadPersistentStores() { (description, error) in
            
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        setUniversityPresets()
    }
    
    // MARK: - Lazy Initialization of Default Student
    lazy var defaultStudent: Student = {
        var students = [Student]()
        
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_STUDENT)
        request.predicate = predicate
        
        do {
            try students = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        if students.count == 0 {
            return addStudent(name: DEFAULT_STUDENT)
        }
        
        return students.first!
    }()
    

    
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    //MARK: - Database Protocol Functions
    func cleanup() {
        saveContext()
    }
    
    func addStudent(name: String) -> Student {
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: persistentContainer.viewContext) as! Student
        
        student.name = name
        
        return student
    }
    

    func addSubject(name: String, code: String, grade: String, points: Double, score: Double, year: Int16, favourite: Bool) -> Subject {
        let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: persistentContainer.viewContext) as! Subject
        subject.name = name
        subject.code = code
        subject.grade = grade
        subject.points = points
        subject.year = year
        subject.score = score
        subject.isFavourite = false
        
        debugPrint(addSubjectToStudent(student: defaultStudent, subject: subject))
        
        return subject
    
    }
    
    
    
    func addSubjectToStudent(student: Student, subject: Subject) -> Bool {
        student.addToSubjects(subject)
        return true
    }
    
    func deleteSubject(subject: Subject) {
        persistentContainer.viewContext.delete(subject)
        removeSubjectFromStudent(subject: subject, student: defaultStudent)
    }
    
    func deleteStudent(student: Student) {
        persistentContainer.viewContext.delete(student)
    }
    
    func removeSubjectFromStudent(subject: Subject, student: Student) {
        student.removeFromSubjects(subject)
        
    }
    
    func addUniversity(name: String, grades: [String], weights: [Double]) {
        let university = NSEntityDescription.insertNewObject(forEntityName: "University", into: persistentContainer.viewContext) as! University
        university.name = name
        university.grades = grades
        university.weights = weights
        
    }
    
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .students || listener.listenerType == .all {
            listener.onStudentChange(change: .update, studentSubjects: fetchStudentSubjects())
        }
        
        if listener.listenerType == .subjects || listener.listenerType == .all {
            listener.onSubjectChange(change: .update, subjects: fetchAllSubjects())
        }
        
        if listener.listenerType == .university || listener.listenerType == .all {
            listener.onSubjectChange(change: .update, subjects: fetchAllSubjects())
        }
    }
    

    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    // MARK: - Fetched Results Controller Protocol Functions
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSubjectsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .subjects || listener.listenerType == .all {
                    listener.onSubjectChange(change: .update, subjects: fetchAllSubjects())
                }
            }
        } else if controller == studentSubjectsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .students || listener.listenerType == .all {
                    listener.onStudentChange(change: .update, studentSubjects: fetchStudentSubjects())
                }
            }
        } else if controller == allUniversitiesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .university || listener.listenerType == .all {
                    listener.onUniversityChange(change: .update, universities: fetchAllUniversities())
                }
            }
        }
    }
    
    // MARK: - Core Data Fetch Requests
    
    func fetchAllSubjects() -> [Subject] {
        // if results controller not currenty initialised
        if allSubjectsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "year", ascending: false)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // Initialize Results Controller
            allSubjectsFetchedResultsController = NSFetchedResultsController<Subject>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allSubjectsFetchedResultsController?.delegate = self
            
            do {
                try allSubjectsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var subjects = [Subject]()
        if allSubjectsFetchedResultsController?.fetchedObjects != nil {
            subjects = (allSubjectsFetchedResultsController?.fetchedObjects)!
        }
        
//        debugPrint(subjects)
        
        return subjects
        
        
    }
    
    func fetchStudentSubjects() -> [Subject] {
        if studentSubjectsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY student.name == %@", DEFAULT_STUDENT)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            
            studentSubjectsFetchedResultsController = NSFetchedResultsController<Subject>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            studentSubjectsFetchedResultsController?.delegate = self
            
            do {
                try studentSubjectsFetchedResultsController?.performFetch()
                
            } catch {
                debugPrint("Fetch Request Failed: \(error)")
            }
        }
        
        var subjects = [Subject]()
        
        if studentSubjectsFetchedResultsController?.fetchedObjects != nil {
            subjects = (studentSubjectsFetchedResultsController?.fetchedObjects)!
        }
        
        return subjects
    }
    
    
    func fetchAllUniversities() -> [University] {
        // if results controller not currenty initialised
        if allUniversitiesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<University> = University.fetchRequest()
            
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // Initialize Results Controller
            allUniversitiesFetchedResultsController = NSFetchedResultsController<University>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allUniversitiesFetchedResultsController?.delegate = self
            
            do {
                try allUniversitiesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var universities = [University]()
        if allUniversitiesFetchedResultsController?.fetchedObjects != nil {
            universities = (allUniversitiesFetchedResultsController?.fetchedObjects)!
        }
        
        debugPrint(universities)
        
        return universities
        
    }
    
    func setUniversityPresets() {
        addUniversity(name: "Monash University", grades: ["High Distinction", "Distinction", "Credit", "Pass", "Near Pass", "Fail", "Hurdle Fail", "Withdrawn Fail"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        //addUniversity(name: "Melbourne University", grades: ["H1", "H2A", "H2B", "H3", "P", "N", "NH", "S"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        addUniversity(name: "La Trobe University", grades: ["High Distinction", "Distinction", "Credit", "Pass", "Near Pass", "Fail", "Hurdle Fail", "Withdrawn Fail"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        addUniversity(name: "Deakin University", grades: ["HD", "D", "C", "P", "N", "F", "PC", "XN", "WN"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        addUniversity(name: "Victoria University", grades: ["High Distinction", "Distinction", "Credit", "Pass", "Near Pass", "Fail", "Hurdle Fail", "Withdrawn Fail"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        addUniversity(name: "RMIT University", grades: ["High Distinction", "Distinction", "Credit", "Pass", "Near Pass", "Fail", "Hurdle Fail", "Withdrawn Fail"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        addUniversity(name: "Swinburne University", grades: ["High Distinction", "Distinction", "Credit", "Pass", "Near Pass", "Fail", "Hurdle Fail", "Withdrawn Fail"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
    }
    
    
    
}
