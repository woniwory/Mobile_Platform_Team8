package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Repository.QuestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    public Question createQuestion(Question question) {
        return questionRepository.save(question);
    }

    public Question updateQuestion(Long id, Question questionDetails) {
        Optional<Question> optionalQuestion = questionRepository.findById(id);
        if (optionalQuestion.isPresent()) {
            Question question = optionalQuestion.get();
            // Update surveyId, required, questionText if necessary
            question.setSurveyId(questionDetails.getSurveyId());
            question.setRequired(questionDetails.isRequired());
            question.setQuestionText(questionDetails.getQuestionText());
            return questionRepository.save(question);
        } else {
            return null; // or throw exception
        }
    }

    public void deleteQuestion(Long id) {
        questionRepository.deleteById(id);
    }
}
