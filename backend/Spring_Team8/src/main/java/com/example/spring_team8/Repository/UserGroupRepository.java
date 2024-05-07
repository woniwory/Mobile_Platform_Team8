package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.UserGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserGroupRepository extends JpaRepository<UserGroup, Long> {
    List<UserGroup> findByGroup_Id(Long groupId); // Correct the property name to match the Group entity's primary key
    @Query("SELECT ug.survey.surveyTitle FROM UserGroup ug WHERE ug.group.id = :groupId")
    List<String> findSurveyTitlesByGroupId(Long groupId);
}
