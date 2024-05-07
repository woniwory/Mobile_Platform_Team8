package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Repository.SurveyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SurveyService {

    @Autowired
    private SurveyRepository surveyRepository;

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
}
