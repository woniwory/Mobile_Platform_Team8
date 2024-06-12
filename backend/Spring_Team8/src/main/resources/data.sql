-- src/main/resources/data.sql

INSERT INTO user (user_email, user_name, user_password) VALUES ('woniwory@naver.com','정성원','정성원Password');
INSERT INTO user (user_email, user_name, user_password) VALUES ('mwiliams@naver.com','이호영','이호영Password');

INSERT INTO `group` (group_name) VALUES ('group1');
INSERT INTO `group` (group_name) VALUES ('group2');
INSERT INTO `group` (group_name) VALUES ('group3');





INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title1','survey1 description','2024-05-18', '2024-05-20',15,10000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title2','survey2 description','2024-05-20', '2024-05-21',20,20000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title3','survey3 description','2024-05-22', '2024-05-23',25,30000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title4','survey4 description','2024-05-24', '2024-05-25',30,40000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title5','survey5 description','2024-05-26', '2024-05-27',35,50000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title6','survey6 description','2024-05-28', '2024-05-29',40,60000);
INSERT INTO survey (survey_title, survey_description, survey_start_date, survey_end_date, participants,required_payment) VALUES ('survey title7','survey7 description','2024-05-30', '2024-05-31',45,70000);

INSERT INTO `user_group` (user_id,group_id, survey_id) VALUES (1,1,1);
INSERT INTO `user_group` (user_id,group_id,survey_id) VALUES (1,1,2);


INSERT INTO user_survey (user_id, survey_id,is_admin,fee_status) VALUES (1,2,true,false);
INSERT INTO user_survey (user_id, survey_id,is_admin,fee_status) VALUES (1,3,true,false);



INSERT INTO question (survey_id, question_text,required,type) VALUES (1,'what language?',true,true);
INSERT INTO question (survey_id, question_text,required,type) VALUES (1,'why?',true,false);
INSERT INTO question (survey_id, question_text,required,type) VALUES (2,'what time?',false,false);
INSERT INTO question (survey_id, question_text,required,type) VALUES (2,'what food ??',true,true);


INSERT INTO choice (question_id, choice_text) VALUES (1,'Python');
INSERT INTO choice (question_id, choice_text) VALUES (1,'Java');
INSERT INTO choice (question_id, choice_text) VALUES (1,'C++');
INSERT INTO choice (question_id, choice_text) VALUES (4,'돈까스');
INSERT INTO choice (question_id, choice_text) VALUES (4,'Food1');
INSERT INTO choice (question_id, choice_text) VALUES (4,'Food2');

INSERT INTO response (question_id, user_id, choice_id) VALUES (1,1,1);
INSERT INTO response (question_id, user_id, response_text) VALUES (2,1,'fun');
-- INSERT INTO response (question_id, user_id, choiceId, response_text) VALUES (2,1,'just');
-- INSERT INTO response (question_id, user_id, choiceId, response_text) VALUES (2,2,'fun');


-- INSERT INTO response (question_id, user_id, response_text) VALUES (3,1,'12');
-- INSERT INTO response (question_id, user_id, response_text) VALUES (3,2,'1');
-- INSERT INTO response (question_id, user_id, response_text) VALUES (4,1,'1');
-- INSERT INTO response (question_id, user_id, response_text) VALUES (4,2,'3');

