package com.example.spring_team8.Entity;

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

    private Long questionId;

    private String choiceText;
}
