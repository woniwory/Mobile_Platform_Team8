package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Repository.UserSurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserSurveyService {

    @Autowired
    private UserSurveyRepository userSurveyRepository;

    public List<UserSurvey> getAllUserSurveys() {
        return userSurveyRepository.findAll();
    }

    public UserSurvey getUserSurveyById(Long id) {
        Optional<UserSurvey> userSurveyOptional = userSurveyRepository.findById(id);
        if (userSurveyOptional.isPresent()) {
            return userSurveyOptional.get();
        }
        throw new RuntimeException("UserSurvey not found for id: " + id);
    }

    public UserSurvey createOrUpdateUserSurvey(UserSurvey userSurvey) {
        return userSurveyRepository.save(userSurvey);
    }

    public void deleteUserSurvey(Long id) {
        userSurveyRepository.deleteById(id);
    }
}
