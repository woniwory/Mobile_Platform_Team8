package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Repository.UserSurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserSurveyService {

    @Autowired
    private UserSurveyRepository userSurveyRepository;

    public List<UserSurvey> getAllUserSurveys() {
        return userSurveyRepository.findAll();
    }


    public UserSurvey createOrUpdateUserSurvey(UserSurvey userSurvey) {
        return userSurveyRepository.save(userSurvey);
    }

    public void deleteUserSurvey(Long id) {
        userSurveyRepository.deleteById(id);
    }

    public Optional<UserSurvey> findByUserId(Long userId) { return userSurveyRepository.findById(userId); }


    public UserSurvey updateFeeStatus(UserSurvey userSurvey) {
        userSurvey.setFeeStatus(true);
        return userSurveyRepository.save(userSurvey);
    }


    public Optional<UserSurvey> getUserSurveyBySurveyId(Long surveyId) {
        return userSurveyRepository.findById(surveyId);
    }

    public Optional<UserSurvey> getUserSurveyByUserIdAndSurveyId(Long userId, Long surveyId) {
        return userSurveyRepository.findByUserUserIdAndSurveySurveyId(userId, surveyId);
    }
}
