package com.example.spring_team8.Service;

import com.example.spring_team8.Entity.Survey;
import com.example.spring_team8.Entity.User;
import com.example.spring_team8.Entity.UserSurvey;
import com.example.spring_team8.Repository.UserRepository;
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

    public User updateUser(Long userId, User userDetails) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            User existingUser = user.get();
            existingUser.setUserName(userDetails.getUserName());
            existingUser.setUserEmail(userDetails.getUserEmail());
            existingUser.setUserPassword(userDetails.getUserPassword());
            existingUser.setUserAccountNumber(userDetails.getUserAccountNumber());
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
}
