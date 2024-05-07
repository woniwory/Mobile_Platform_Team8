package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Service.UserSurveyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;



@RestController
@RequestMapping("/user-surveys")
public class UserSurveyController {

    @Autowired
    private UserSurveyService userSurveyService;

    @GetMapping
    public ResponseEntity<List<UserSurvey>> getAllUserSurveys() {
        List<UserSurvey> userSurveys = userSurveyService.getAllUserSurveys();
        return new ResponseEntity<>(userSurveys, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserSurvey> getUserSurveyById(@PathVariable("id") Long id) {
        UserSurvey userSurvey = userSurveyService.getUserSurveyById(id);
        return new ResponseEntity<>(userSurvey, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<UserSurvey> createUserSurvey(@RequestBody UserSurvey userSurvey) {
        UserSurvey createdUserSurvey = userSurveyService.createOrUpdateUserSurvey(userSurvey);
        return new ResponseEntity<>(createdUserSurvey, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserSurvey> updateUserSurvey(@PathVariable("id") Long id, @RequestBody UserSurvey userSurvey) {
        userSurvey.setId(id);
        UserSurvey updatedUserSurvey = userSurveyService.createOrUpdateUserSurvey(userSurvey);
        return new ResponseEntity<>(updatedUserSurvey, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUserSurvey(@PathVariable("id") Long id) {
        userSurveyService.deleteUserSurvey(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
