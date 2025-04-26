DROP TABLE IF EXISTS actions CASCADE;
DROP TABLE IF EXISTS persons CASCADE;
DROP TABLE IF EXISTS packs CASCADE;
DROP TABLE IF EXISTS pack_of_ducknose CASCADE;
DROP TABLE IF EXISTS pack_of_tirano CASCADE;
DROP TABLE IF EXISTS dinosaurs CASCADE;
DROP TABLE IF EXISTS identifiers CASCADE;
DROP TABLE IF EXISTS dinosaur_food CASCADE;
DROP TABLE IF EXISTS foods CASCADE;
DROP TABLE IF EXISTS watching_for_actions CASCADE;

CREATE TABLE packs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE persons (
    id SERIAL PRIMARY KEY,  
    name VARCHAR(255) NOT NULL  
);


CREATE TABLE identifiers (
    id SERIAL PRIMARY KEY,  
    identifier VARCHAR(255) UNIQUE NOT NULL  
);

CREATE TABLE foods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) CHECK (type IN ('Растительная', 'Животная', 'Всеяд'))
);

CREATE TABLE dinosaurs (
    id SERIAL PRIMARY KEY,
    species VARCHAR(255) NOT NULL,
    age CHAR(1) CHECK (age IN ('A', 'C')),
    sex CHAR(1) CHECK (sex IN ('M', 'F')),
    name VARCHAR(255),
    identifier_id INT UNIQUE NOT NULL,
    pack_id INT NOT NULL, 
    FOREIGN KEY (identifier_id) REFERENCES identifiers(id),
    FOREIGN KEY (pack_id) REFERENCES packs(id)
);

CREATE TABLE actions (
    id SERIAL PRIMARY KEY,  
    action_name VARCHAR(255) NOT NULL,
    performer_pack_id INT NOT NULL, 
    FOREIGN KEY (performer_pack_id) REFERENCES packs(id)  
);

CREATE TABLE dinosaur_food (
    id SERIAL PRIMARY KEY,
    dinosaur_id INT NOT NULL,
    food_id INT NOT NULL,
    food_amount INT NOT NULL,
    FOREIGN KEY (dinosaur_id) REFERENCES dinosaurs(id),
    FOREIGN KEY (food_id) REFERENCES foods(id)
);

CREATE TABLE watching_for_actions (
    id SERIAL PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    action_id INT NOT NULL,
    person_id INT NULL,
    FOREIGN KEY (action_id) REFERENCES actions(id), 
    FOREIGN KEY (person_id) REFERENCES persons(id) 
);


INSERT INTO packs (name) VALUES
('Утконосые (стая)'),
('Тиранозавры (стая)');


INSERT INTO persons (name) VALUES
('Грант');


INSERT INTO identifiers (identifier) VALUES
('D-A-M-001'),
('D-A-F-002'),
('D-C-M-003'),
('D-C-F-004'),
('T-A-M-005'),
('T-A-F-006'),
('T-C-M-007'),
('T-C-F-008');


INSERT INTO dinosaurs (species, age, sex, name, identifier_id, pack_id) VALUES
('Утконосый динозавр', 'A', 'M', 'Утк1', 1, 1),
('Утконосый динозавр', 'A', 'F', 'Утк2', 2, 1),
('Утконосый динозавр', 'C', 'M', 'Утк3', 3, 1),
('Утконосый динозавр', 'C', 'F', 'Утк4', 4, 1),
('Тиранозавр', 'A', 'M', 'Тир5', 5, 2),
('Тиранозавр', 'A', 'F', 'Тир6', 6, 2),
('Тиранозавр', 'C', 'M', 'Тир7', 7, 2),
('Тиранозавр', 'C', 'F', 'Тир8', 8, 2);

INSERT INTO foods (name, type) VALUES
('Листья', 'Растительная'),
('Хвоя', 'Растительная'),
('Млекопитающие', 'Животная'),
('Рыба', 'Животная'),
('Мясо утконосых', 'Животная'),
('Растения', 'Растительная'),
('Насекомые', 'Всеяд');

INSERT INTO dinosaur_food (dinosaur_id, food_id, food_amount) VALUES
(1, 1, 200),  
(1, 2, 250), 
(2, 1, 200), 
(5, 3, 170),
(5, 4, 175), 
(5, 5, 180); 


INSERT INTO actions (action_name, performer_pack_id) VALUES
('Мчались', 1),
('Бежали', 1),     
('Визжали', 1),  
('Не попадались под ноги', 1),   
('Подняла облако пыли', 1),        
('Охотились', 2);

INSERT INTO watching_for_actions (description, action_id, person_id) VALUES
('Наблюдал за охотой', 6, 1),
('Не видел из-за пыли', 5, 1);