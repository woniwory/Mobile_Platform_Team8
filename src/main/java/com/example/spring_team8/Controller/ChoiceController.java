package com.example.spring_team8.Controller;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Service.ChoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/choices")
public class ChoiceController {

    @Autowired
    private ChoiceService choiceService;

    @GetMapping
    public ResponseEntity<List<Choice>> getAllChoices() {
        List<Choice> choices = choiceService.getAllChoices();
        return new ResponseEntity<>(choices, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Choice> getChoiceById(@PathVariable Long id) {
        Optional<Choice> choice = choiceService.getChoiceById(id);
        return choice.map(value -> new ResponseEntity<>(value, HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<Choice> createChoice(@RequestBody Choice choice) {
        Choice createdChoice = choiceService.createChoice(choice);
        return new ResponseEntity<>(createdChoice, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Choice> updateChoice(@PathVariable Long id, @RequestBody Choice choiceDetails) {
        Choice updatedChoice = choiceService.updateChoice(id, choiceDetails);
        return updatedChoice != null ? new ResponseEntity<>(updatedChoice, HttpStatus.OK) : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteChoice(@PathVariable Long id) {
        choiceService.deleteChoice(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
