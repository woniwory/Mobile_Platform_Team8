package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Repository.QuestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class QuestionService {

    @Autowired
    private QuestionRepository questionRepository;

    public List<Question> getAllQuestions() {
        return questionRepository.findAll();
    }

    public Optional<Question> getQuestionById(Long id) {
        return questionRepository.findById(id);
    }

    public List<Question> createQuestions(List<Question> questions) {
        List<Question> createdQuestions = new ArrayList<>();
        for (Question question : questions) {
            createdQuestions.add(questionRepository.save(question));
        }
        return createdQuestions;
    }

    public void deleteQuestion(Long id) {
        questionRepository.deleteById(id);
    }


    public List<Question> getQuestionsBySurveyId(Long surveyId) {
        return questionRepository.findBySurveySurveyId(surveyId);
    }


}
