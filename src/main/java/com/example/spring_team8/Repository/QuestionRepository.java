package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuestionRepository extends JpaRepository<Question, Long> {
}
