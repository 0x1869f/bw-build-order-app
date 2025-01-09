CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS race(name VARCHAR(7) UNIQUE NOT NULL PRIMARY KEY);

INSERT INTO race (name) VALUES ('protoss'), ('terran'), ('zerg') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS unit(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    type SMALLINT NOT NULL DEFAULT 1, -- unit type: 0 - worker, 1 - battle unit 
    image VARCHAR(140) NOT NULL,
    supply_cost SMALLINT NOT NULL,
    supply SMALLINT DEFAULT 0
);

INSERT INTO unit (race, type, name, image, supply_cost, supply) VALUES
    ('protoss', 0, 'probe', '', 1, 0),
    ('protoss', 1, 'zealot', '', 2, 0),
    ('protoss', 1, 'dragoon', '', 2, 0),
    ('protoss', 1, 'high templar', '', 2, 0),
    ('protoss', 1, 'dark templar', '', 2, 0),
    ('protoss', 1, 'reaver', '', 4, 0),
    ('protoss', 1, 'archon', '', 0, 0),
    ('protoss', 1, 'dark archon', '', 0, 0),
    ('protoss', 1, 'observer', '', 1, 0),
    ('protoss', 1, 'shuttle', '', 2, 0),
    ('protoss', 1, 'scout', '', 3, 0), 
    ('protoss', 1, 'carrier', '', 6, 0),
    ('protoss', 1, 'arbiter', '', 4, 0),
    ('protoss', 1, 'corsair', '', 2, 0),
    -- terran units
    ('terran', 0, 'scv', '', 1, 0),
    ('terran', 1, 'marine', '', 1, 0),
    ('terran', 1, 'firebat', '', 1, 0),
    ('terran', 1, 'medic', '', 1, 0),
    ('terran', 1, 'ghost', '', 1, 0),
    ('terran', 1, 'vulture', '', 2, 0),
    ('terran', 1, 'siege tank', '', 2, 0),
    ('terran', 1, 'goliath', '', 2, 0),
    ('terran', 1, 'wraith', '', 2, 0),
    ('terran', 1, 'dropship', '', 2, 0),
    ('terran', 1, 'science vessel', '', 2, 0), 
    ('terran', 1, 'battlecruiser', '', 6, 0),
    ('terran', 1, 'valkyrie', '', 3, 0),
    -- zerg units
    ('zerg', 0, 'drone', '', 1, 0),
    ('zerg', 1, 'zergling', '', 1, 0),
    ('zerg', 1, 'hydralisk', '', 1, 0),
    ('zerg', 1, 'lurker', '', 1, 0),
    ('zerg', 1, 'ultralisk', '', 4, 0),
    ('zerg', 1, 'defiler', '', 4, 0),
    ('zerg', 1, 'overlord', '', 0, 8),
    ('zerg', 1, 'mutalisk', '', 2, 0),
    ('zerg', 1, 'scourge', '', 1, 0),
    ('zerg', 1, 'queen', '', 2, 0),
    ('zerg', 1, 'guardian', '', 0, 0),
    ('zerg', 1, 'devourer', '', 0, 0)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS building(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    image VARCHAR(140) NOT NULL,
    supply SMALLINT DEFAULT 0,
    worker_cost SMALLINT NOT NULL DEFAULT 0
);

INSERT INTO building (race, name, image, supply, worker_cost) VALUES
    ('protoss', 'nexus', '', 9, 0),
    ('protoss', 'pylon', '', 8, 0),
    ('protoss', 'assimilator', '', 0, 0),
    ('protoss', 'gateway', '', 0, 0),
    ('protoss', 'forge', '', 0, 0),
    ('protoss', 'forge', '', 0, 0),
    ('protoss', 'shield battery', '', 0, 0),
    ('protoss', 'cybernetics core', '', 0, 0),
    ('protoss', 'photon cannon', '', 0, 0),
    ('protoss', 'robotics facility', '', 0, 0),
    ('protoss', 'stargate', '', 0, 0),
    ('protoss', 'citadel of adun', '', 0, 0),
    ('protoss', 'robotics support bay', '', 0, 0),
    ('protoss', 'fleet beacon', '', 0, 0),
    ('protoss', 'templar archives', '', 0, 0),
    ('protoss', 'observatory', '', 0, 0),
    ('protoss', 'arbiter tribunal', '', 0, 0),
    -- terran buildings
    ('terran', 'arbiter tribunal', '', 0, 0),
    ('terran', 'command center', '', 10, 0),
    ('terran', 'supply depot', '', 8, 0),
    ('terran', 'refinery', '', 0, 0),
    ('terran', 'barracks', '', 0, 0),
    ('terran', 'engineering bay', '', 0, 0),
    ('terran', 'bunker', '', 0, 0),
    ('terran', 'academy', '', 0, 0),
    ('terran', 'missile turret', '', 0, 0),
    ('terran', 'factory', '', 0, 0),
    ('terran', 'machine shop', '', 0, 0),
    ('terran', 'starport', '', 0, 0),
    ('terran', 'control tower', '', 0, 0),
    ('terran', 'armory', '', 0, 0),
    ('terran', 'science facility', '', 0, 0),
    ('terran', 'physics lab', '', 0, 0),
    ('terran', 'covert ops', '', 0, 0),
    ('terran', 'comsat station', '', 0, 0),
    ('terran', 'nuclear silo', '', 0, 0),
    -- zerg buildings
    ('zerg', 'hatchery', '', 1, 1),
    ('zerg', 'extractor', '', 0, 1),
    ('zerg', 'spawning pool', '', 0, 1),
    ('zerg', 'evolution chamber', '', 0, 1),
    ('zerg', 'hydralisk den', '', 0, 1),
    ('zerg', 'creep colony', '', 0, 1),
    ('zerg', 'sunken colony', '', 0, 0),
    ('zerg', 'spore colony', '', 0, 0),
    ('zerg', 'lair', '', 0, 0),
    ('zerg', 'spire', '', 0, 1),
    ('zerg', 'queen''s nest', '', 0, 1),
    ('zerg', 'hive', '', 0, 0),
    ('zerg', 'greater spire', '', 0, 0),
    ('zerg', 'nydus canal', '', 0, 1),
    ('zerg', 'ultralisk cavern', '', 0, 1),
    ('zerg', 'defiler mound', '', 0, 1)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS upgrade(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    image VARCHAR(140) NOT NULL
);

INSERT INTO upgrade (race, name, image) VALUES
    ('protoss', 'ground weapons', ''),
    ('protoss', 'ground armor', ''),
    ('protoss', 'plasma shields', ''),
    ('protoss', 'air armor', ''),
    ('protoss', 'air weapons', ''),
    ('protoss', 'singularity charge', ''),
    ('protoss', 'leg enhancements', ''),
    ('protoss', 'scarab damage', ''),
    ('protoss', 'increased reaver capacity', ''),
    ('protoss', 'gravitic drive', ''),
    ('protoss', 'carrier capacity', ''),
    ('protoss', 'apial sensors', ''),
    ('protoss', 'gravitic thrusters', ''),
    ('protoss', 'disruption web', ''),
    ('protoss', 'argus jewel', ''),
    ('protoss', 'psionic storm', ''),
    ('protoss', 'hallucination', ''),
    ('protoss', 'khaydarin amulet', ''),
    ('protoss', 'maelstrom', ''),
    ('protoss', 'mind control', ''),
    ('protoss', 'argus talisman', ''),
    ('protoss', 'sensor array', ''),
    ('protoss', 'gravitic booster', ''),
    ('protoss', 'stasis field', ''),
    ('protoss', 'recall', ''),
    ('protoss', 'khaydarin core', ''),
    -- terran upgrades
    ('terran', 'infantry weapons', ''),
    ('terran', 'infantry armor', ''),
    ('terran', 'stim pack', ''),
    ('terran', 'u-238 shells', ''),
    ('terran', 'restoration', ''),
    ('terran', 'optical flare', ''),
    ('terran', 'caduceus reactor', ''),
    ('terran', 'siege tech', ''),
    ('terran', 'spider mines', ''),
    ('terran', 'ion thrusters', ''),
    ('terran', 'charon boosters', ''),
    ('terran', 'vehicle weapons', ''),
    ('terran', 'vehicle plating', ''),
    ('terran', 'ship weapons', ''),
    ('terran', 'ship plating', ''),
    ('terran', 'cloaking field', ''),
    ('terran', 'apollo reactor', ''),
    ('terran', 'yamato gun', ''),
    ('terran', 'colossus reactor', ''),
    ('terran', 'personnel cloaking', ''),
    ('terran', 'lockdown', ''),
    ('terran', 'ocular implants', ''),
    ('terran', 'moebius reactor', ''),
    ('terran', 'nuclear strike', ''),
    -- zerg upgrade
    ('zerg', 'burrow', ''),
    ('zerg', 'metabolic boost', ''),
    ('zerg', 'adrenal glands', ''),
    ('zerg', 'zerg melee attacks', ''),
    ('zerg', 'zerg missile attacks', ''),
    ('zerg', 'zerg carapace', ''),
    ('zerg', 'muscular augments', ''),
    ('zerg', 'grooved spines', ''),
    ('zerg', 'lurker aspect', ''),
    ('zerg', 'ventral sacs', ''),
    ('zerg', 'antennae', ''),
    ('zerg', 'pneumatized carapace', ''),
    ('zerg', 'flyer attack', ''),
    ('zerg', 'flyer carapace', ''),
    ('zerg', 'ensnare', ''),
    ('zerg', 'spawn broodling', ''),
    ('zerg', 'gamete meiosis', ''),
    ('zerg', 'anabolic synthesis', ''),
    ('zerg', 'chitinous plating', ''),
    ('zerg', 'consume', ''),
    ('zerg', 'plague', ''),
    ('zerg', 'metasynaptic node', '')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS role(
    id SMALLINT PRIMARY KEY,
    name CHAR(5) UNIQUE NOT NULL
);

INSERT INTO role (id, name) VALUES
    (0, 'root'),
    (1, 'admin'),
    (2, 'user')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS app_user(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    login VARCHAR(60) UNIQUE NOT NULL,
    nickname VARCHAR(60) NOT NULL,
    password CHAR(128) NOT NULL,
    role SMALLINT REFERENCES role (id) ON DELETE RESTRICT,
    registered_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS tag(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(40) NOT NULL,
    race VARCHAR(7) REFERENCES race (name),
    creator UUID REFERENCES app_user (id) ON DELETE RESTRICT
);

ALTER TABLE tag ADD CONSTRAINT uniq_name_race UNIQUE (name, race);

CREATE TABLE IF NOT EXISTS build_order(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description TEXT NUll DEFAULT NULL,
    name VARCHAR(120) NOT NULL,
    creator UUID REFERENCES app_user (id) ON DELETE RESTRICT,
    race VARCHAR(7) REFERENCES race (name),
    opponent_race VARCHAR(7) REFERENCES race (name)
);

CREATE TABLE IF NOT EXISTS build_order_tag(
    build_order UUID REFERENCES build_order (id) ON DELETE CASCADE,
    tag UUID REFERENCES tag (id) ON DELETE CASCADE,
    UNIQUE (build_order, tag)
);

CREATE OR REPLACE FUNCTION build_order_tag_check_same_race()
RETURNS TRIGGER AS $build_order_tag_check_same_race$
    DECLARE
      tag_race VARCHAR(7);
    BEGIN
        tag_race := (SELECT race FROM tag WHERE tag.id = NEW.tag);

        IF (SELECT race FROM build_order WHERE build_order.id = NEW.build_order) != tag_race THEN
            IF (SELECT opponent_race FROM build_order WHERE build_order.id = NEW.build_order) != tag_race THEN
                RAISE EXCEPTION 'ERROR: A tag must have the same race as the build order';
            END IF;
        END IF;

        RETURN NEW;
    END;
$build_order_tag_check_same_race$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER build_order_tag_check_same_race BEFORE INSERT OR UPDATE ON build_order_tag FOR EACH ROW EXECUTE FUNCTION build_order_tag_check_same_race();

CREATE INDEX IF NOT EXISTS build_order_tag_build_id_index ON build_order_tag (build_order);

CREATE TABLE IF NOT EXISTS build_order_step(
    build_order UUID REFERENCES build_order (id) ON DELETE CASCADE,
    unit VARCHAR(40) NULL REFERENCES unit (name) DEFAULT NULL,
    building VARCHAR(40) NULL REFERENCES building (name) DEFAULT NULL,
    upgrade VARCHAR(40) NULL REFERENCES upgrade (name) DEFAULT NULL,
    is_removable BOOLEAN NOT NULL,
    is_canceled BOOLEAN NOT NULL,
    comment TEXT NULL DEFAULT NULL,
    supply_limit_up_by SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT one_not_null CHECK (
      (unit IS NOT NULL)::int + 
      (building IS NOT NULL)::int + 
      (upgrade IS NOT NULL)::int = 1
    )
);

CREATE OR REPLACE FUNCTION build_order_step_check_same_race()
RETURNS TRIGGER AS $build_order_step_check_same_race$
    DECLARE
      build_order_race VARCHAR(7);
    BEGIN
        build_order_race := (SELECT race FROM build_order WHERE build_order.id = NEW.build_order);

        IF (NEW.unit IS NOT NULL) THEN
            IF  build_order_race != (SELECT race FROM unit WHERE unit.name = NEW.unit) THEN
                RAISE EXCEPTION 'ERROR: An unit must have the same race as the build order';
            END IF;
        ELSIF (NEW.building IS NOT NULL) THEN
            IF build_order_race != (SELECT race FROM building WHERE building.name = NEW.building) THEN
                RAISE EXCEPTION 'ERROR: A building must have the same race as the build order';
            END IF;
        ELSE
            IF build_order_race != (SELECT race FROM upgrade WHERE upgrade.name = NEW.upgrade) THEN
                RAISE EXCEPTION 'ERROR: An upgrade must have the same race as the build order';
            END IF;
        END IF;

        RETURN NEW;
    END;
$build_order_step_check_same_race$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER build_order_step_check_same_race BEFORE INSERT OR UPDATE ON build_order_step FOR EACH ROW EXECUTE FUNCTION build_order_step_check_same_race();

CREATE INDEX IF NOT EXISTS build_order_step_build_id_index ON build_order_step (build_order);

CREATE TABLE IF NOT EXISTS build_order_link(
  build_order UUID REFERENCES build_order (id) ON DELETE CASCADE,
  link VARCHAR(200) NOT NULL
);

CREATE INDEX IF NOT EXISTS build_order_link_build_id_index ON build_order_link (build_order);

CREATE TABLE IF NOT EXISTS player(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator UUID REFERENCES app_user (id),
    race VARCHAR(7) NOT NULL REFERENCES race (name),
    nickname VARCHAR(15) NOT NULL,
    bio TEXT NULL DEFAULT NULL,
    avatar VARCHAR(200) NULL DEFAULT NULL,
    soop VARCHAR(200) NULL DEFAULT NULL,
    youtube VARCHAR(200) NULL DEFAULT NULL,
    twitch VARCHAR(200) NULL DEFAULT NULL,
    liquipedia VARCHAR(200) NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS map(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(60) UNIQUE,
    image VARCHAR(200) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS replay(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(200) NUll DEFAULT NULL,
    map VARCHAR(60) NOT NULL REFERENCES map (name),
    creator UUID REFERENCES app_user (id),
    player UUID NOT NULL REFERENCES player (id),
    race VARCHAR(7) REFERENCES race (name),
    first_build_order UUID NOT NULL REFERENCES build_order (id),
    second_player UUID REFERENCES player (id) NULL DEFAULT NULL,
    second_race VARCHAR(7) REFERENCES race (name),
    second_build_order UUID NUll REFERENCES build_order (id) DEFAULT NULL,
    file VARCHAR(200) NULL DEFAULT NULL
);

