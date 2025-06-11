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
    identifier_id INT PRIMARY KEY,
    species VARCHAR(255) NOT NULL,
    age CHAR(1) CHECK (age IN ('A', 'C')),
    sex CHAR(1) CHECK (sex IN ('M', 'F')),
    name VARCHAR(255),
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
    dinosaur_id INT NOT NULL,
    food_id INT NOT NULL,
    food_amount INT NOT NULL,
    PRIMARY KEY (dinosaur_id, food_id),
    FOREIGN KEY (dinosaur_id) REFERENCES dinosaurs(identifier_id),
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

INSERT INTO dinosaurs (identifier_id, species, age, sex, name, pack_id) VALUES
(1, 'Утконосый динозавр', 'A', 'M', 'Утк1', 1),
(2, 'Утконосый динозавр', 'A', 'F', 'Утк2', 1),
(3, 'Утконосый динозавр', 'C', 'M', 'Утк3', 1),
(4, 'Утконосый динозавр', 'C', 'F', 'Утк4', 1),
(5, 'Тиранозавр', 'A', 'M', 'Тир5', 2),
(6, 'Тиранозавр', 'A', 'F', 'Тир6', 2),
(7, 'Тиранозавр', 'C', 'M', 'Тир7', 2),
(8, 'Тиранозавр', 'C', 'F', 'Тир8', 2);

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


CREATE OR REPLACE FUNCTION check_pack_after_death()
RETURNS TRIGGER AS $$
DECLARE
    pack_size INT;
    action_count INT;
BEGIN
    SELECT COUNT(*) INTO pack_size
    FROM dinosaurs
    WHERE pack_id = OLD.pack_id;

    IF pack_size = 0 THEN
        SELECT COUNT(*) INTO action_count
        FROM actions
        WHERE performer_pack_id = OLD.pack_id;

        IF action_count = 0 THEN
            DELETE FROM packs WHERE id = OLD.pack_id;
        END IF;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER prevent_deletion
AFTER DELETE ON dinosaurs
FOR EACH ROW
EXECUTE FUNCTION check_pack_after_death();