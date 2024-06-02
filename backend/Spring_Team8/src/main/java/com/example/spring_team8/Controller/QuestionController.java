package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Repository.SurveyRepository;
import com.example.spring_team8.Service.ChoiceService;
import com.example.spring_team8.Service.QuestionService;
import com.example.spring_team8.dto.QuestionDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/questions")
public class QuestionController {

    @Autowired
    private QuestionService questionService;

    @Autowired
    private SurveyRepository surveyRepository;

    @Autowired
    private ChoiceService choiceService;



    @GetMapping
    public ResponseEntity<List<Question>> getAllQuestions() {
        List<Question> questions = questionService.getAllQuestions();
        return new ResponseEntity<>(questions, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Question> getQuestionById(@PathVariable Long id) {
        Optional<Question> question = questionService.getQuestionById(id);
        return question.map(value -> new ResponseEntity<>(value, HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<?> createQuestions(@RequestBody List<QuestionDTO> questionDTOs) {
        List<Question> questions = new ArrayList<>();
        for (QuestionDTO dto : questionDTOs) {
            Survey survey = surveyRepository.findById(dto.getSurveyId())
                    .orElseThrow(() -> new RuntimeException("Survey not found"));
            Question question = new Question();
            question.setSurvey(survey);
            question.setQuestionText(dto.getQuestionText());
            question.setRequired(dto.isRequired());
            questions.add(question);
        }
        List<Question> createdQuestions = questionService.createQuestions(questions);
        return new ResponseEntity<>(createdQuestions, HttpStatus.CREATED);
    }



    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuestion(@PathVariable Long id) {
        questionService.deleteQuestion(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @GetMapping("survey/{surveyId}")
    public List<Question> getQuestionsBySurveyId(@PathVariable Long surveyId) {
        List<Question> questions = questionService.getQuestionsBySurveyId(surveyId);
        return questions;
    }
}
