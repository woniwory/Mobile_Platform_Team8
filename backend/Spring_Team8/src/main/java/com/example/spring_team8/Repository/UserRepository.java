package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
