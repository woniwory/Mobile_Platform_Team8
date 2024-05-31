package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserSurveyRepository extends JpaRepository<UserSurvey, Long> {


    Optional<UserSurvey> findByUserUserIdAndSurveySurveyId(Long userId, Long surveyId);
}
