package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.UserGroup;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Service.UserGroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("api/user-groups")
public class UserGroupController {

    @Autowired
    private UserGroupService userGroupService;

    @GetMapping
    public ResponseEntity<List<UserGroup>> getAllUserGroups() {
        List<UserGroup> userGroups = userGroupService.getAllUserGroups();
        return new ResponseEntity<>(userGroups, HttpStatus.OK);
    }

    @GetMapping("/user/{userId}")
    public List<UserGroup> getUserGroupByUserId(@PathVariable("userId") Long userId) {
        return userGroupService.getUserGroupByUserId(userId);
    }


    @PostMapping
    public ResponseEntity<UserGroup> createUserGroup(@RequestBody UserGroup userGroup) {
        UserGroup createdUserGroup = userGroupService.createUserGroup(userGroup);
        return new ResponseEntity<>(createdUserGroup, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserGroup> updateUserGroup(@PathVariable Long id, @RequestBody UserGroup userGroupDetails) {
        UserGroup updatedUserGroup = userGroupService.updateUserGroup(id, userGroupDetails);
        return updatedUserGroup != null ? new ResponseEntity<>(updatedUserGroup, HttpStatus.OK) : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUserGroup(@PathVariable Long id) {
        userGroupService.deleteUserGroup(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

//    @GetMapping("/{groupId}/survey-count")
//    public ResponseEntity<Integer> getSurveyCountByGroupId(@PathVariable("groupId") Long groupId) {
//        int surveyCount = userGroupService.getSurveyCountByGroupId(groupId);
//        return new ResponseEntity<>(surveyCount, HttpStatus.OK);
//    }
//    @GetMapping("/{groupId}/group-count")
//    public ResponseEntity<Integer> getGroupCountByGroupId(@PathVariable("groupId") Long groupId) {
//        int surveyCount = userGroupService.getGroupCountByGroupId(groupId);
//        return new ResponseEntity<>(surveyCount, HttpStatus.OK);
//    }
//
//    @GetMapping("/{groupId}/survey-titles")
//    public ResponseEntity<List<String>> getSurveyTitlesByGroupId(@PathVariable("groupId") Long groupId) {
//        List<String> surveyTitles = userGroupService.getSurveyTitlesByGroupId(groupId);
//        return new ResponseEntity<>(surveyTitles, HttpStatus.OK);
//    }


}
