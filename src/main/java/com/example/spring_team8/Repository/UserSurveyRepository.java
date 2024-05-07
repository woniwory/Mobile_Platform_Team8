package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserSurveyRepository extends JpaRepository<UserSurvey, Long> {
}
