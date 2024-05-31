package com.example.spring_team8.Repository;

import com.example.spring_team8.Entity.UserGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserGroupRepository extends JpaRepository<UserGroup, Long> {



    List<UserGroup> findByUserUserId(Long userId);

}
