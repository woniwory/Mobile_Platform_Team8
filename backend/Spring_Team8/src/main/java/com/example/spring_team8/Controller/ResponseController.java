package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.*;
import com.example.spring_team8.Repository.ChoiceRepository;
import com.example.spring_team8.Repository.QuestionRepository;
import com.example.spring_team8.Repository.UserRepository;
import com.example.spring_team8.Service.QuestionService;
import com.example.spring_team8.Service.ResponseService;
import com.example.spring_team8.dto.QuestionDTO;
import com.example.spring_team8.dto.ResponseDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("api/responses")
public class ResponseController {

    @Autowired
    private ResponseService responseService;


    @Autowired
    private UserRepository userRepository;

    @Autowired
    private QuestionRepository questionRepository;

    @GetMapping
    public ResponseEntity<List<Response>> getAllResponses() {
        List<Response> responses = responseService.getAllResponses();
        return new ResponseEntity<>(responses, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Response> getResponseById(@PathVariable Long id) {
        Optional<Response> response = responseService.getResponseById(id);
        return response.map(value -> new ResponseEntity<>(value, HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<?> createResponses(@RequestBody List<ResponseDTO> responseDTOS) {
        List<Response> responses = new ArrayList<>();
        for (ResponseDTO dto : responseDTOS) {
            Question question = questionRepository.findById(dto.getQuestionId())
                    .orElseThrow(() -> new RuntimeException("Question not found with id: " + dto.getQuestionId()));

            User user = userRepository.findById(dto.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + dto.getUserId()));



            Response response = new Response();
            response.setQuestion(question);
            response.setUser(user);
            response.setResponseText(dto.getResponseText());
            responses.add(response);
        }
        List<Response> createdResponses = responseService.createResponses(responses);
        return new ResponseEntity<>(createdResponses, HttpStatus.CREATED);
    }



    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteResponse(@PathVariable Long id) {
        responseService.deleteResponse(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }


    @GetMapping("/question/{questionId}")
    public List<Response> getResponsesByQuestionId(@PathVariable Long questionId) {
        return responseService.getResponsesByQuestionId(questionId);
    }

}
