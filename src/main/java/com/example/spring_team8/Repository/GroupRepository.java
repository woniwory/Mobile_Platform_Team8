package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Group;
import com.example.spring_team8.Entity.Survey;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GroupRepository extends JpaRepository<Group, Long> {
}
