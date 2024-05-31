package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.Response;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResponseRepository extends JpaRepository<Response, Long> {
    List<Response> findByQuestionQuestionId(Long questionId);
//    List<Response> findByUserIdAndQuestionId(Long userId, Long questionId);
}
