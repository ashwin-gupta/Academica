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
    var editingContext: NSManagedObjectContext
    
    // Fetched Results Controllers
    var allSubjectsFetchedResultsController: NSFetchedResultsController<Subject>?
    var studentSubjectsFetchedResultsController: NSFetchedResultsController<Subject>?
    var allAssessmentsFetchedResultsController:
        NSFetchedResultsController<Assessment>?
    var SubjectAssessmentsFetchedResultsController:
        NSFetchedResultsController<Assessment>?
    var allUniversitiesFetchedResultsController: NSFetchedResultsController<University>?
    
    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "AcademicaDataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        editingContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        editingContext.parent = persistentContainer.viewContext
        
        super.init()
        
        print(fetchAllUniversities())
        
//        if fetchAllUniversities().count == 0 {
//            createUniversities()
//            print(fetchAllUniversities())
//
//        }

        
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
    

    func addSubject(name: String, code: String, grade: String, points: Double, score: Double, year: Int16, favourite: Bool, inProgress: Bool) -> Subject {
        let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: persistentContainer.viewContext) as! Subject
        subject.name = name
        subject.code = code
        subject.grade = grade
        subject.points = points
        subject.year = year
        subject.score = score
        subject.isFavourite = false
        subject.inProgress = inProgress
        
        debugPrint(addSubjectToStudent(student: defaultStudent, subject: subject))
        
        return subject
    
    }
    
    
    func addSubjectToStudent(student: Student, subject: Subject) -> Bool {
        student.addToSubjects(subject)
        return true
    }
    
    func addUniversity(name: String, gradeName: [String], weights: [Double], grades: [String], isSelected: Bool) -> University {
        let university = NSEntityDescription.insertNewObject(forEntityName: "University", into: persistentContainer.viewContext) as! University
        
        
        
        university.name = name
        university.grades = grades
        university.gradeName = gradeName
        university.weights = weights
        university.isSelected = isSelected
        defaultStudent.addToUniversity(university)
        debugPrint(university)
        
        return university
    }
    

    
    
    
    func addAssessment(name: String, dueDate: String, weighting: Double, score: Double, completion: Bool, subject: Subject) -> Assessment {
        
        guard let context = subject.managedObjectContext else {
            fatalError("Subject without context passed to addAssessment")
        }
        
        let assessment = NSEntityDescription.insertNewObject(forEntityName: "Assessment", into: context) as! Assessment
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        assessment.name = name
        assessment.score = score
        assessment.subject = subject
        assessment.weighting = weighting
        assessment.isCompleted = completion
        
        if !assessment.isCompleted {
            assessment.dueDate = dateFormatter.date(from: dueDate)
            
        }
        
        return assessment
        
    }
    
    func deleteAssessment(subject: Subject, assessment: Assessment) {
        
        guard let context = subject.managedObjectContext else {
            fatalError("Subject without context passed to deleteAssessment")
        }
        context.delete(assessment)
        removeAssessmentFromSubject(subject: subject , assessment: assessment)
    }
    
    func deleteUniversity(university: University) {
        defaultStudent.removeFromUniversity(university)
        
    }
    
    func removeAssessmentFromSubject(subject: Subject, assessment: Assessment) {
        subject.removeFromAssessments(assessment)
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
    
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .students || listener.listenerType == .all {
            listener.onStudentChange(change: .update, studentSubjects: fetchStudentSubjects())
        }
        
        if listener.listenerType == .subjects || listener.listenerType == .all {
            listener.onSubjectChange(change: .update, subjects: fetchAllSubjects())
        }
        
        if listener.listenerType == .assessment || listener.listenerType == .all {
            listener.onAssessmentChange(change: .update, assessments: fetchAllAssessments())
        }
        
        if listener.listenerType == .university || listener.listenerType == .all {
            listener.onUniversityChange(change: .update, university: fetchAllUniversities())
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
        } else if controller == allAssessmentsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .assessment || listener.listenerType == .all {
                    listener.onAssessmentChange(change: .update, assessments: fetchAllAssessments())
                }
            }
        } else if controller == allUniversitiesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .university || listener.listenerType == .all {
                    listener.onUniversityChange(change: .update, university: fetchAllUniversities())
                    
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
            allSubjectsFetchedResultsController?.delegate = self
            
            do {
                try allSubjectsFetchedResultsController?.performFetch()
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
    
    func fetchAllAssessments() -> [Assessment] {
        // if results controller not currenty initialised
        if allAssessmentsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
            
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // Initialize Results Controller
            allAssessmentsFetchedResultsController = NSFetchedResultsController<Assessment>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allAssessmentsFetchedResultsController?.delegate = self
            
            do {
                try allAssessmentsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var assessments = [Assessment]()
        if allAssessmentsFetchedResultsController?.fetchedObjects != nil {
            assessments = (allAssessmentsFetchedResultsController?.fetchedObjects)!
        }
        
        return assessments
        
        
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
    
    func createEditableSubject(existingSubject newSubject: Subject?) -> Subject {
        editingContext.rollback()
        
        if let existingSubject = newSubject {
            return editingContext.object(with: existingSubject.objectID) as! Subject
        }
        
        let newSubject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: editingContext) as! Subject
        
        return newSubject
    }
    
    func createEditableAssessment(existingAssessment newAssessment: Assessment?) -> Assessment {
        if let existingAssesment = newAssessment {
            return editingContext.object(with: existingAssesment.objectID) as! Assessment
        }
        
        let newAssessment = NSEntityDescription.insertNewObject(forEntityName: "Assessment", into: editingContext) as! Assessment
        
        return newAssessment
        
    }
    
    func saveEdits() {
        if editingContext.hasChanges {
            do {
                try editingContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func createUniversities() {
        
        let monashGradeNames = ["High Distinction", "Distinction", "Credit", "Pass", "Fail", "Withdrawn Fail", "Hurdle Fail", "Satisfied Faculty Requirements", "First Class Honours", "Second Class Honours Division A", "Second Class Honours Division B", "Third Class Honours", "Not Satisfied Requirements"]
        
        let monashGrades = ["HD", "D", "C", "P", "N", "WN", "NH", "SFR", "HI", "HIIA", "HIIB", "HIII", "NSR"]
        
        let monashWeights = [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0.0, 0.0, 4.0, 3.0, 2.0, 1.0]
        
        let _ = addUniversity(name: "Monash University", gradeName: monashGradeNames, weights: monashWeights, grades: monashGrades, isSelected: true)
        
        
        
        
    }
//
//    func test() {
//        let testSubject = addSubject(name: "Test", code: "TST1000", grade: "HD", points: 6, score: 80, year: Int16(2020), favourite: true, inProgress: true)
//
//        let testAssessment = addAssessment(name: "TestAssessment", dueDate: "2020", weighting: 40, score: 0, completion: true, subject: testSubject)
//
//
//
//    }
    
    
}
