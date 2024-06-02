package com.example.spring_team8.Controller;
import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Service.UserSurveyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@CrossOrigin("*")
@RestController
@RequestMapping("api/user-surveys")
public class UserSurveyController {

    @Autowired
    private UserSurveyService userSurveyService;

    @GetMapping
    public ResponseEntity<List<UserSurvey>> getAllUserSurveys() {
        List<UserSurvey> userSurveys = userSurveyService.getAllUserSurveys();
        return new ResponseEntity<>(userSurveys, HttpStatus.OK);
    }

    @GetMapping("/{surveyId}")
    public ResponseEntity<UserSurvey> getUserSurveyById(@PathVariable("surveyId") Long surveyId) {
        Optional<UserSurvey> userSurvey = userSurveyService.getUserSurveyBySurveyId(surveyId);
        if (userSurvey.isPresent()) {
            return new ResponseEntity<>(userSurvey.get(), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
    
    @PostMapping
    public ResponseEntity<UserSurvey> createUserSurvey(@RequestBody UserSurvey userSurvey) {
        UserSurvey createdUserSurvey = userSurveyService.createOrUpdateUserSurvey(userSurvey);
        return new ResponseEntity<>(createdUserSurvey, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserSurvey> updateUserSurvey(@PathVariable("id") Long id, @RequestBody UserSurvey userSurvey) {
        userSurvey.setUserSurveyId(id);
        UserSurvey updatedUserSurvey = userSurveyService.createOrUpdateUserSurvey(userSurvey);
        return new ResponseEntity<>(updatedUserSurvey, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUserSurvey(@PathVariable("id") Long id) {
        userSurveyService.deleteUserSurvey(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PutMapping("/user/{userId}/survey/{surveyId}")
    public ResponseEntity<UserSurvey> activateFeeStatus(@PathVariable Long userId, @PathVariable Long surveyId) {
        Optional<UserSurvey> optionalUserSurvey = userSurveyService.getUserSurveyByUserIdAndSurveyId(userId, surveyId);
        if (optionalUserSurvey.isPresent()) {
            UserSurvey userSurvey = optionalUserSurvey.get();
            userSurvey.setFeeStatus(true); // Set feeStatus to true
            UserSurvey updatedUserSurvey = userSurveyService.updateFeeStatus(userSurvey);
            return ResponseEntity.ok(updatedUserSurvey);
        } else {
            return ResponseEntity.notFound().build();
        }
    }




}
