package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserSurveyRepository extends JpaRepository<UserSurvey, Long> {

    List<UserSurvey> findByUserUserIdAndSurveyGroupGroupId(Long userId, Long groupId);

    UserSurvey findUserUserIdBySurveySurveyIdAndIsAdminTrue(Long surveyId);
}
