package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Repository.QuestionRepository;
import com.example.spring_team8.Service.ChoiceService;
import com.example.spring_team8.dto.ChoiceDTO;
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
@RequestMapping("api/choices")
public class ChoiceController {

    @Autowired
    private ChoiceService choiceService;
    @Autowired
    private QuestionRepository questionRepository;

    @GetMapping
    public ResponseEntity<List<Choice>> getAllChoices() {
        List<Choice> choices = choiceService.getAllChoices();
        return new ResponseEntity<>(choices, HttpStatus.OK);
    }

    @GetMapping("question/{questionid}")
    public ResponseEntity<List<Choice>> getChoicesByQuestionId(@PathVariable Long questionid) {
        List<Choice> choices = choiceService.getChoicesByQuestionId(questionid);
        return new ResponseEntity<>(choices, HttpStatus.OK);
    }



    @PostMapping
    public ResponseEntity<List<Choice>> createChoices(@RequestBody List<ChoiceDTO> choiceDTOs) {
        List<Choice> createdChoices = new ArrayList<>();
        for (ChoiceDTO choiceDTO : choiceDTOs) {
            try {
                Choice createdChoice = choiceService.createChoice(choiceDTO);
                createdChoices.add(createdChoice);
                System.out.println("Created choice: " + createdChoice);
            } catch (RuntimeException e) {
                System.err.println("Error creating choice: " + e.getMessage());
            }
        }
        return new ResponseEntity<>(createdChoices, HttpStatus.CREATED);
    }



    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteChoice(@PathVariable Long id) {
        choiceService.deleteChoice(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

//    @GetMapping("survey/{surveyId}")
//    public List<Choice> getChoicesBySurveyId(@PathVariable Long surveyId) {
//        List<Choice> choices = choiceService.getChoicesBySurveyId(surveyId);
//        return choices;
//    }
}
