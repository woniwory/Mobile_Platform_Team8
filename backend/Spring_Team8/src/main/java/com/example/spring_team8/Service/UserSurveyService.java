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

    public Optional<UserSurvey> getUserSurveyById(Long id) { return userSurveyRepository.findById(id);
    }

    public List<Survey> getSurveysByUserIdAndGroupId(Long userId, Long groupId) {
        return userSurveyRepository.findByUserUserIdAndSurveyGroupGroupId(userId, groupId)
                .stream()
                .map(UserSurvey::getSurvey)
                .collect(Collectors.toList());
    }





}
