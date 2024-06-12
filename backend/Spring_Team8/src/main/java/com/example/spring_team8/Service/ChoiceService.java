package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Entity.Question;
import com.example.spring_team8.Repository.ChoiceRepository;
import com.example.spring_team8.Repository.QuestionRepository;
import com.example.spring_team8.dto.ChoiceDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ChoiceService {

    @Autowired
    private ChoiceRepository choiceRepository;
    @Autowired
    private QuestionRepository questionRepository;



    public List<Choice> getAllChoices() {
        return choiceRepository.findAll();
    }

    public List<Choice> getChoicesByQuestionId(Long id) {
        return choiceRepository.findByQuestionQuestionId(id);
    }

    public Choice createChoice(ChoiceDTO choiceDTO) {
        System.out.println("Creating choice for question ID: " + choiceDTO.getQuestionId());

        Question question = questionRepository.findById(choiceDTO.getQuestionId())
                .orElseThrow(() -> new RuntimeException("Question not found: " + choiceDTO.getQuestionId()));

        Choice choice = new Choice();
        choice.setQuestion(question);
        choice.setChoiceText(choiceDTO.getChoiceText());
        choice.setType(choiceDTO.getType());


        System.out.println("Saving choice: " + choice);

        try {
            Choice savedChoice = choiceRepository.save(choice);
            System.out.println("Saved choice ID: " + savedChoice.getChoiceId());
            return savedChoice;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to save choice: " + e.getMessage());
        }
    }



    public void deleteChoice(Long id) {
        choiceRepository.deleteById(id);
    }


    public List<Choice> createChoices(List<Choice> choices) {
        List<Choice> createdChoices = new ArrayList<>();
        for (Choice choice : choices) {
            createdChoices.add(choiceRepository.save(choice));
        }
        return createdChoices;
    }

}

