package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.User;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Repository.UserRepository;
import com.example.spring_team8.dto.UserDTO;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    private UserSurveyService userSurveyRepository;
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(Long userId) {
        return userRepository.findById(userId);
    }

    public User createUser(User user) {
        return userRepository.save(user);
    }

    @Transactional
    public User updateUser(Long userId, UserDTO userDto) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User existingUser = userOptional.get();
            existingUser.setUserName(userDto.getUserName());
            existingUser.setUserEmail(userDto.getUserEmail());
            existingUser.setUserPassword(userDto.getUserPassword());
            existingUser.setUserAccountNumber(userDto.getUserAccountNumber());
            return userRepository.save(existingUser);
        } else {
            return null;
        }
    }

    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }


    public List<Survey> getUserSurveys(Long userId) {
        Optional<UserSurvey> userSurveys = userSurveyRepository.findByUserId(userId);
        return userSurveys.stream()
                .map(UserSurvey::getSurvey)
                .collect(Collectors.toList());
    }


    public Optional<User> authenticateUser(String email, String password) {
        Optional<User> userOptional = userRepository.findByUserEmail(email);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (password.equals(user.getUserPassword())) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

}
