package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Repository.ChoiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ChoiceService {

    @Autowired
    private ChoiceRepository choiceRepository;

    public List<Choice> getAllChoices() {
        return choiceRepository.findAll();
    }

    public Optional<Choice> getChoiceById(Long id) {
        return choiceRepository.findById(id);
    }

    public Choice createChoice(Choice choice) {
        return choiceRepository.save(choice);
    }

    public Choice updateChoice(Long id, Choice choiceDetails) {
        Optional<Choice> optionalChoice = choiceRepository.findById(id);
        if (optionalChoice.isPresent()) {
            Choice choice = optionalChoice.get();
            // Update questionId, choiceText if necessary
            choice.setQuestionId(choiceDetails.getQuestionId());
            choice.setChoiceText(choiceDetails.getChoiceText());
            return choiceRepository.save(choice);
        } else {
            return null; // or throw exception
        }
    }

    public void deleteChoice(Long id) {
        choiceRepository.deleteById(id);
    }
}
