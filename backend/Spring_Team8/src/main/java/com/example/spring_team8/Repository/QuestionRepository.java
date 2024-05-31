package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {
    List<Question> findBySurveySurveyId(Long surveyId);
}
