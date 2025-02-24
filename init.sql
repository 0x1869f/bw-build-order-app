\c bw

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS race(
  name VARCHAR(7) UNIQUE NOT NULL PRIMARY KEY,
  icon VARCHAR(140) NOT NULL
);

INSERT INTO race (name, icon) VALUES
  ('protoss', '/static/bw/protoss/icon.png'),
  ('terran', '/static/bw/terran/icon.png'),
  ('zerg', '/static/bw/zerg/icon.png')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS unit(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    type SMALLINT NOT NULL DEFAULT 1, -- unit type: 0 - worker, 1 - battle unit 
    image VARCHAR(140) NOT NULL,
    supply_cost SMALLINT NOT NULL,
    supply SMALLINT DEFAULT 0
);

INSERT INTO unit (race, type, name, image, supply_cost, supply) VALUES
    ('protoss', 0, 'probe', '/static/bw/protoss/unit/probe.png', 1, 0),
    ('protoss', 1, 'zealot', '/static/bw/protoss/unit/zealot.png', 2, 0),
    ('protoss', 1, 'dragoon', '/static/bw/protoss/unit/dragoon.png', 2, 0),
    ('protoss', 1, 'high templar', '/static/bw/protoss/unit/high-templar.png', 2, 0),
    ('protoss', 1, 'dark templar', '/static/bw/protoss/unit/dark-templar.png', 2, 0),
    ('protoss', 1, 'reaver', '/static/bw/protoss/unit/reaver.png', 4, 0),
    ('protoss', 1, 'archon', '/static/bw/protoss/unit/archon.png', 0, 0),
    ('protoss', 1, 'dark archon', '/static/bw/protoss/unit/dark-archon.png', 0, 0),
    ('protoss', 1, 'observer', '/static/bw/protoss/unit/observer.png', 1, 0),
    ('protoss', 1, 'shuttle', '/static/bw/protoss/unit/shuttle.png', 2, 0),
    ('protoss', 1, 'scout', '/static/bw/protoss/unit/scout.png', 3, 0), 
    ('protoss', 1, 'carrier', '/static/bw/protoss/unit/carrier.png', 6, 0),
    ('protoss', 1, 'arbiter', '/static/bw/protoss/unit/arbiter.png', 4, 0),
    ('protoss', 1, 'corsair', '/static/bw/protoss/unit/corsair.png', 2, 0),
    -- terran units
    ('terran', 0, 'scv', '/static/bw/terran/unit/scv.png', 1, 0),
    ('terran', 1, 'marine', '/static/bw/terran/unit/marine.png', 1, 0),
    ('terran', 1, 'firebat', '/static/bw/terran/unit/firebat.png', 1, 0),
    ('terran', 1, 'medic', '/static/bw/terran/unit/medic.png', 1, 0),
    ('terran', 1, 'ghost', '/static/bw/terran/unit/ghost.png', 1, 0),
    ('terran', 1, 'vulture', '/static/bw/terran/unit/vulture.png', 2, 0),
    ('terran', 1, 'siege tank', '/static/bw/terran/unit/siege-tank.png', 2, 0),
    ('terran', 1, 'goliath', '/static/bw/terran/unit/goliath.png', 2, 0),
    ('terran', 1, 'wraith', '/static/bw/terran/unit/wraith.png', 2, 0),
    ('terran', 1, 'dropship', '/static/bw/terran/unit/dropship.png', 2, 0),
    ('terran', 1, 'science vessel', '/static/bw/terran/unit/science-vessel.png', 2, 0), 
    ('terran', 1, 'battlecruiser', '/static/bw/terran/unit/battlecruiser.png', 6, 0),
    ('terran', 1, 'valkyrie', '/static/bw/terran/unit/valkyrie.png', 3, 0),
    -- zerg units
    ('zerg', 0, 'drone', '/static/bw/zerg/unit/drone.png', 1, 0),
    ('zerg', 1, 'zergling', '/static/bw/zerg/unit/zergling.png', 1, 0),
    ('zerg', 1, 'hydralisk', '/static/bw/zerg/unit/hydralisk.png', 1, 0),
    ('zerg', 1, 'lurker', '/static/bw/zerg/unit/lurker.png', 1, 0),
    ('zerg', 1, 'ultralisk', '/static/bw/zerg/unit/ultralisk.png', 4, 0),
    ('zerg', 1, 'defiler', '/static/bw/zerg/unit/defiler.png', 4, 0),
    ('zerg', 1, 'overlord', '/static/bw/zerg/unit/overlord.png', 0, 8),
    ('zerg', 1, 'mutalisk', '/static/bw/zerg/unit/mutalisk.png', 2, 0),
    ('zerg', 1, 'scourge', '/static/bw/zerg/unit/scourge.png', 1, 0),
    ('zerg', 1, 'queen', '/static/bw/zerg/unit/queen.png', 2, 0),
    ('zerg', 1, 'guardian', '/static/bw/zerg/unit/guardian.png', 0, 0),
    ('zerg', 1, 'devourer', '/static/bw/zerg/unit/devourer.png', 0, 0)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS building(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    image VARCHAR(140) NOT NULL,
    supply SMALLINT DEFAULT 0,
    worker_cost SMALLINT NOT NULL DEFAULT 0
);

INSERT INTO building (race, name, image, supply, worker_cost) VALUES
    ('protoss', 'nexus', '/static/bw/protoss/building/nexus.png', 9, 0),
    ('protoss', 'pylon', '/static/bw/protoss/building/pylon.png', 8, 0),
    ('protoss', 'assimilator', '/static/bw/protoss/building/assimilator.png', 0, 0),
    ('protoss', 'gateway', '/static/bw/protoss/building/gateway.png', 0, 0),
    ('protoss', 'forge', '/static/bw/protoss/building/forge.png', 0, 0),
    ('protoss', 'shield battery', '/static/bw/protoss/building/shield-battery.png', 0, 0),
    ('protoss', 'cybernetics core', '/static/bw/protoss/building/cybernetics-core.png', 0, 0),
    ('protoss', 'photon cannon', '/static/bw/protoss/building/photon-cannon.png', 0, 0),
    ('protoss', 'robotics facility', '/static/bw/protoss/building/robotics-facility.png', 0, 0),
    ('protoss', 'stargate', '/static/bw/protoss/building/stargate.png', 0, 0),
    ('protoss', 'citadel of adun', '/static/bw/protoss/building/citadel-of-adun.png', 0, 0),
    ('protoss', 'robotics support bay', '/static/bw/protoss/building/robotics-support-bay.png', 0, 0),
    ('protoss', 'fleet beacon', '/static/bw/protoss/building/fleet-beacon.png', 0, 0),
    ('protoss', 'templar archives', '/static/bw/protoss/building/templar-archives.png', 0, 0),
    ('protoss', 'observatory', '/static/bw/protoss/building/observatory.png', 0, 0),
    ('protoss', 'arbiter tribunal', '/static/bw/protoss/building/arbiter-tribunal.png', 0, 0),
    -- terran buildings
    ('terran', 'command center', '/static/bw/terran/building/command-center.png', 10, 0),
    ('terran', 'supply depot', '/static/bw/terran/building/supply-depot.png', 8, 0),
    ('terran', 'refinery', '/static/bw/terran/building/refinery.png', 0, 0),
    ('terran', 'barracks', '/static/bw/terran/building/barracks.png', 0, 0),
    ('terran', 'engineering bay', '/static/bw/terran/building/engineering-bay.png', 0, 0),
    ('terran', 'bunker', '/static/bw/terran/building/bunker.png', 0, 0),
    ('terran', 'academy', '/static/bw/terran/building/academy.png', 0, 0),
    ('terran', 'missile turret', '/static/bw/terran/building/missile-turret.png', 0, 0),
    ('terran', 'factory', '/static/bw/terran/building/factory.png', 0, 0),
    ('terran', 'machine shop', '/static/bw/terran/building/machine-shop.png', 0, 0),
    ('terran', 'starport', '/static/bw/terran/building/starport.png', 0, 0),
    ('terran', 'control tower', '/static/bw/terran/building/control-tower.png', 0, 0),
    ('terran', 'armory', '/static/bw/terran/building/armory.png', 0, 0),
    ('terran', 'science facility', '/static/bw/terran/building/science-facility.png', 0, 0),
    ('terran', 'physics lab', '/static/bw/terran/building/physics-lab.png', 0, 0),
    ('terran', 'covert ops', '/static/bw/terran/building/covert-ops.png', 0, 0),
    ('terran', 'comsat station', '/static/bw/terran/building/comsat-station.png', 0, 0),
    ('terran', 'nuclear silo', '/static/bw/terran/building/nuclear-silo.png', 0, 0),
    -- zerg buildings
    ('zerg', 'hatchery', '/static/bw/zerg/building/hatchery.png', 1, 1),
    ('zerg', 'extractor', '/static/bw/zerg/building/extractor.png', 0, 1),
    ('zerg', 'spawning pool', '/static/bw/zerg/building/spawning-pool.png', 0, 1),
    ('zerg', 'evolution chamber', '/static/bw/zerg/building/evolution-chamber.png', 0, 1),
    ('zerg', 'hydralisk den', '/static/bw/zerg/building/hydralisk-den.png', 0, 1),
    ('zerg', 'creep colony', '/static/bw/zerg/building/creep-colony.png', 0, 1),
    ('zerg', 'sunken colony', '/static/bw/zerg/building/sunken-colony.png', 0, 0),
    ('zerg', 'spore colony', '/static/bw/zerg/building/spore-colony.png', 0, 0),
    ('zerg', 'lair', '/static/bw/zerg/building/lair.png', 0, 0),
    ('zerg', 'spire', '/static/bw/zerg/building/spire.png', 0, 1),
    ('zerg', 'queen''s nest', '/static/bw/zerg/building/queens-nest.png', 0, 1),
    ('zerg', 'hive', '/static/bw/zerg/building/hive.png', 0, 0),
    ('zerg', 'greater spire', '/static/bw/zerg/building/greater-spire.png', 0, 0),
    ('zerg', 'nydus canal', '/static/bw/zerg/building/nydus-canal.png', 0, 1),
    ('zerg', 'ultralisk cavern', '/static/bw/zerg/building/ultralisk-cavern.png', 0, 1),
    ('zerg', 'defiler mound', '/static/bw/zerg/building/defiler-mound.png', 0, 1)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS upgrade(
    name VARCHAR(40) PRIMARY KEY,
    race VARCHAR(7) REFERENCES race (name),
    image VARCHAR(140) NOT NULL
);

INSERT INTO upgrade (race, name, image) VALUES
    ('protoss', 'ground weapons', '/static/bw/protoss/upgrade/ground-weapons.png'),
    ('protoss', 'ground armor', '/static/bw/protoss/upgrade/ground-armor.png'),
    ('protoss', 'plasma shields', '/static/bw/protoss/upgrade/plasma-shields.png'),
    ('protoss', 'air armor', '/static/bw/protoss/upgrade/air-armor.png'),
    ('protoss', 'air weapons', '/static/bw/protoss/upgrade/air-weapons.png'),
    ('protoss', 'singularity charge', '/static/bw/protoss/upgrade/singularity-charge.png'),
    ('protoss', 'leg enhancements', '/static/bw/protoss/upgrade/leg-enhancements.png'),
    ('protoss', 'scarab damage', '/static/bw/protoss/upgrade/scarab-damage.png'),
    ('protoss', 'increased reaver capacity', '/static/bw/protoss/upgrade/increased-reaver-capacity.png'),
    ('protoss', 'gravitic drive', '/static/bw/protoss/upgrade/gravitic-drive.png'),
    ('protoss', 'carrier capacity', '/static/bw/protoss/upgrade/carrier-capacity.png'),
    ('protoss', 'apial sensors', '/static/bw/protoss/upgrade/apial-sensors.png'),
    ('protoss', 'gravitic thrusters', '/static/bw/protoss/upgrade/gravitic-thrusters.png'),
    ('protoss', 'disruption web', '/static/bw/protoss/upgrade/disruption-web.png'),
    ('protoss', 'argus jewel', '/static/bw/protoss/upgrade/argus-jewel.png'),
    ('protoss', 'psionic storm', '/static/bw/protoss/upgrade/psionic-storm.png'),
    ('protoss', 'hallucination', '/static/bw/protoss/upgrade/hallucination.png'),
    ('protoss', 'khaydarin amulet', '/static/bw/protoss/upgrade/khaydarin-amulet.png'),
    ('protoss', 'maelstrom', '/static/bw/protoss/upgrade/maelstrom.png'),
    ('protoss', 'mind control', '/static/bw/protoss/upgrade/mind-control.png'),
    ('protoss', 'argus talisman', '/static/bw/protoss/upgrade/argus-talisman.png'),
    ('protoss', 'sensor array', '/static/bw/protoss/upgrade/sensor-array.png'),
    ('protoss', 'gravitic booster', '/static/bw/protoss/upgrade/gravitic-booster.png'),
    ('protoss', 'stasis field', '/static/bw/protoss/upgrade/stasis-field.png'),
    ('protoss', 'recall', '/static/bw/protoss/upgrade/recall.png'),
    ('protoss', 'khaydarin core', '/static/bw/protoss/upgrade/khaydarin-core.png'),
    -- terran upgrades
    ('terran', 'infantry weapons', '/static/bw/terran/upgrade/infantry-weapons.png'),
    ('terran', 'infantry armor', '/static/bw/terran/upgrade/infantry-armor.png'),
    ('terran', 'stim pack', '/static/bw/terran/upgrade/stim-pack.png'),
    ('terran', 'u-238 shells', '/static/bw/terran/upgrade/u-238-shells.png'),
    ('terran', 'restoration', '/static/bw/terran/upgrade/restoration.png'),
    ('terran', 'optical flare', '/static/bw/terran/upgrade/optical-flare.png'),
    ('terran', 'caduceus reactor', '/static/bw/terran/upgrade/caduceus-reactor.png'),
    ('terran', 'siege tech', '/static/bw/terran/upgrade/siege-tech.png'),
    ('terran', 'spider mines', '/static/bw/terran/upgrade/spider-mines.png'),
    ('terran', 'ion thrusters', '/static/bw/terran/upgrade/ion-thrusters.png'),
    ('terran', 'charon boosters', '/static/bw/terran/upgrade/charon-boosters.png'),
    ('terran', 'vehicle weapons', '/static/bw/terran/upgrade/vehicle-weapons.png'),
    ('terran', 'vehicle plating', '/static/bw/terran/upgrade/vehicle-plating.png'),
    ('terran', 'ship weapons', '/static/bw/terran/upgrade/ship-weapons.png'),
    ('terran', 'ship plating', '/static/bw/terran/upgrade/ship-plating.png'),
    ('terran', 'cloaking field', '/static/bw/terran/upgrade/cloaking-field.png'),
    ('terran', 'apollo reactor', '/static/bw/terran/upgrade/apollo-reactor.png'),
    ('terran', 'yamato gun', '/static/bw/terran/upgrade/yamato-gun.png'),
    ('terran', 'colossus reactor', '/static/bw/terran/upgrade/colossus-reactor.png'),
    ('terran', 'personnel cloaking', '/static/bw/terran/upgrade/personnel-cloaking.png'),
    ('terran', 'lockdown', '/static/bw/terran/upgrade/lockdown.png'),
    ('terran', 'ocular implants', '/static/bw/terran/upgrade/ocular-implants.png'),
    ('terran', 'moebius reactor', '/static/bw/terran/upgrade/moebius-reactor.png'),
    ('terran', 'nuclear strike', '/static/bw/terran/upgrade/nuclear-strike.png'),
    -- zerg upgrade
    ('zerg', 'burrow', '/static/bw/zerg/upgrade/burrow.png'),
    ('zerg', 'metabolic boost', '/static/bw/zerg/upgrade/metabolic-boost.png'),
    ('zerg', 'adrenal glands', '/static/bw/zerg/upgrade/adrenal-glands.png'),
    ('zerg', 'zerg melee attacks', '/static/bw/zerg/upgrade/zerg-melee-attacks.png'),
    ('zerg', 'zerg missile attacks', '/static/bw/zerg/upgrade/zerg-missile-attacks.png'),
    ('zerg', 'zerg carapace', '/static/bw/zerg/upgrade/zerg-carapace.png'),
    ('zerg', 'muscular augments', '/static/bw/zerg/upgrade/muscular-augments.png'),
    ('zerg', 'grooved spines', '/static/bw/zerg/upgrade/grooved-spines.png'),
    ('zerg', 'lurker aspect', '/static/bw/zerg/upgrade/lurker-aspect.png'),
    ('zerg', 'ventral sacs', '/static/bw/zerg/upgrade/ventral-sacs.png'),
    ('zerg', 'antennae', '/static/bw/zerg/upgrade/antennae.png'),
    ('zerg', 'pneumatized carapace', '/static/bw/zerg/upgrade/pneumatized-carapace.png'),
    ('zerg', 'flyer attack', '/static/bw/zerg/upgrade/flyer-attack.png'),
    ('zerg', 'flyer carapace', '/static/bw/zerg/upgrade/flyer-carapace.png'),
    ('zerg', 'ensnare', '/static/bw/zerg/upgrade/ensnare.png'),
    ('zerg', 'spawn broodling', '/static/bw/zerg/upgrade/spawn-broodling.png'),
    ('zerg', 'gamete meiosis', '/static/bw/zerg/upgrade/gamete-meiosis.png'),
    ('zerg', 'anabolic synthesis', '/static/bw/zerg/upgrade/anabolic-synthesis.png'),
    ('zerg', 'chitinous plating', '/static/bw/zerg/upgrade/chitinous-plating.png'),
    ('zerg', 'consume', '/static/bw/zerg/upgrade/consume.png'),
    ('zerg', 'plague', '/static/bw/zerg/upgrade/plague.png'),
    ('zerg', 'metasynaptic node', '/static/bw/zerg/upgrade/metasynaptic-node.png')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS external_service(
  name VARCHAR(15) PRIMARY KEY,
  icon VARCHAR(200) NOT NULL
);

INSERT INTO external_service (name, icon) VALUES
    ('soop', '/static/external-service/soop.png'),
    ('youtube', '/static/external-service/youtube.png'),
    ('twitch', '/static/external-service/twitch.png'),
    ('liquipedia', '/static/external-service/liquipedia.png')
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
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    opponent_race VARCHAR(7) REFERENCES race (name),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    map UUID NOT NULL REFERENCES map (id),
    creator UUID REFERENCES app_user (id),
    player UUID NOT NULL REFERENCES player (id),
    race VARCHAR(7) REFERENCES race (name),
    build_order UUID NOT NULL REFERENCES build_order (id),
    second_player UUID REFERENCES player (id) NULL DEFAULT NULL,
    second_race VARCHAR(7) REFERENCES race (name),
    second_build_order UUID NUll REFERENCES build_order (id) DEFAULT NULL,
    file VARCHAR(200) NULL DEFAULT NULL
);

