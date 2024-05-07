package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Response;
import com.example.spring_team8.Repository.ResponseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ResponseService {

    @Autowired
    private ResponseRepository responseRepository;

    public List<Response> getAllResponses() {
        return responseRepository.findAll();
    }

    public Optional<Response> getResponseById(Long id) {
        return responseRepository.findById(id);
    }

    public Response createResponse(Response response) {
        return responseRepository.save(response);
    }

    public Response updateResponse(Long id, Response responseDetails) {
        Optional<Response> optionalResponse = responseRepository.findById(id);
        if (optionalResponse.isPresent()) {
            Response response = optionalResponse.get();
            // Update questionId, userId, choiceId, responseText if necessary
            response.setQuestionId(responseDetails.getQuestionId());
            response.setUserId(responseDetails.getUserId());
            response.setChoiceId(responseDetails.getChoiceId());
            response.setResponseText(responseDetails.getResponseText());
            return responseRepository.save(response);
        } else {
            return null; // or throw exception
        }
    }

    public void deleteResponse(Long id) {
        responseRepository.deleteById(id);
    }
}
