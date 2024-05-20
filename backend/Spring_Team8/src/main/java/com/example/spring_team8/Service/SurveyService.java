package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Repository.SurveyRepository;
import com.example.spring_team8.Repository.UserSurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SurveyService {

    @Autowired
    private SurveyRepository surveyRepository;
    @Autowired
    private UserSurveyRepository userSurveyRepository;

    public List<Survey> getAllSurveys() {
        return surveyRepository.findAll();
    }

    public Survey getSurveyById(Long id) {
        Optional<Survey> surveyOptional = surveyRepository.findById(id);
        if (surveyOptional.isPresent()) {
            return surveyOptional.get();
        }
        throw new RuntimeException("Survey not found for id: " + id);
    }

    public Survey createOrUpdateSurvey(Survey survey) {
        return surveyRepository.save(survey);
    }

    public void deleteSurvey(Long id) {
        surveyRepository.deleteById(id);
    }

//    public List<Survey> getSurveysByUserId(Long userId, Long groupId) {
//        List<UserSurvey> userSurveys = userSurveyRepository.findByUserUserIdAndSurveyGroupId(userId, groupId);
//        return userSurveys.stream()
//                .map(UserSurvey::getSurvey)
//                .collect(Collectors.toList());
//    }
}

