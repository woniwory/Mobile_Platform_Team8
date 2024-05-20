package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.Response;
import com.example.spring_team8.Service.ResponseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/responses")
public class ResponseController {

    @Autowired
    private ResponseService responseService;

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
    public ResponseEntity<Response> createResponse(@RequestBody Response response) {
        Response createdResponse = responseService.createResponse(response);
        return new ResponseEntity<>(createdResponse, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Response> updateResponse(@PathVariable Long id, @RequestBody Response responseDetails) {
        Response updatedResponse = responseService.updateResponse(id, responseDetails);
        return updatedResponse != null ? new ResponseEntity<>(updatedResponse, HttpStatus.OK) : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteResponse(@PathVariable Long id) {
        responseService.deleteResponse(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }


    @GetMapping("/user/{userId}/question/{questionId}")
    public List<Response> getResponsesByUserIdAndQuestionId(@PathVariable Long userId, @PathVariable Long questionId) {
        return responseService.getResponsesByUserIdAndQuestionId(userId, questionId);
    }

}
