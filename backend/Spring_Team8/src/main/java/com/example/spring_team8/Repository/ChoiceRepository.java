package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Choice;
import com.example.spring_team8.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChoiceRepository extends JpaRepository<Choice, Long> {
}
