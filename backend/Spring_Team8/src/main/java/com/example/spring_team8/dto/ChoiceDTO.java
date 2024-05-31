package com.example.spring_team8.dto;

import com.example.spring_team8.Entity.Choice;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChoiceDTO {
    private Long choiceId;
    private Long questionId;
    private String choiceText;


}
