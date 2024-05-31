package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Entity.Response;
import com.example.spring_team8.Repository.ResponseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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




    public void deleteResponse(Long id) {
        responseRepository.deleteById(id);
    }

//    public List<Response> getResponsesByUserIdAndQuestionId(Long userId, Long questionId) {
//        return responseRepository.findByUserIdAndQuestionId(userId, questionId);
//    }

    public List<Response> createResponses(List<Response> responses) {
        List<Response> createdResponses = new ArrayList<>();
        for (Response response : responses) {
            createdResponses.add(responseRepository.save(response));
        }
        return createdResponses;
    }

    public List<Response> getResponsesByQuestionId(Long surveyId) {
        return responseRepository.findByQuestionQuestionId(surveyId);
    }
}
