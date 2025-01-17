package com.student.student;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service

public class StudentService {

    private final StudentRepository repository;

    public StudentService(StudentRepository repository) {
        this.repository = repository;
    }

    public void saveStudent(Student student) {
        repository.save(student);
    }

    public List<Student> findAllStudents() {
        return repository.findAll();
    }
}
