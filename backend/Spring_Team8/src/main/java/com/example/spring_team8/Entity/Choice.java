package com.example.spring_team8.Entity;


import com.example.spring_team8.dto.ChoiceDTO;
import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.*;

@Entity
@Table(name = "choice")
@Getter
@Setter
public class Choice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long choiceId;


    @ManyToOne
    @JoinColumn(name = "question_id")
    private Question question;

    private String choiceText;
    private Boolean type;



}
