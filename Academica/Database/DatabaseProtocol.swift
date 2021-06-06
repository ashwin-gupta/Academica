//
//  DatabaseProtocol.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/9/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case students
    case subjects
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject])
    func onSubjectChange(change: DatabaseChange, subjects: [Subject])
    
    
}

protocol DatabaseProtocol: AnyObject {
    var defaultStudent : Student {get}
    
    func cleanup()
    
    func addSubject(name: String, code: String, grade: String, points: Double, score: Double, year: Int16, favourite: Bool) -> Subject

    func addStudent(name: String) -> Student
    
    func addSubjectToStudent(student: Student, subject: Subject) -> Bool
    
    func deleteSubject(subject: Subject)
    
    func deleteStudent(student: Student)
    
    func removeSubjectFromStudent(subject: Subject, student: Student)
    
    func addListener(listener: DatabaseListener)
    
    func removeListener(listener: DatabaseListener)
}
