--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.2
-- Dumped by pg_dump version 9.1.2
-- Started on 2013-01-28 23:10:24

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1915 (class 1262 OID 16403)
-- Name: map; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE map WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


\connect map

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 168 (class 3079 OID 11639)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1917 (class 0 OID 0)
-- Dependencies: 168
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 161 (class 1259 OID 16645)
-- Dependencies: 1874 1875 6
-- Name: achievements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE achievements (
    id text NOT NULL,
    name text NOT NULL,
    maxprogress smallint DEFAULT 1 NOT NULL,
    description text NOT NULL,
    CONSTRAINT achievements_maxprogress_check CHECK ((maxprogress >= 1))
);


--
-- TOC entry 162 (class 1259 OID 16653)
-- Dependencies: 1876 1877 1878 1879 6
-- Name: sprites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sprites (
    parentid character varying(4) NOT NULL,
    src text NOT NULL,
    name text NOT NULL,
    zorder integer,
    x integer DEFAULT 0 NOT NULL,
    y integer DEFAULT 0 NOT NULL,
    inroom boolean DEFAULT true NOT NULL,
    floor smallint NOT NULL,
    CONSTRAINT sprite_zorder_is_positive CHECK ((0 <= zorder))
);


--
-- TOC entry 163 (class 1259 OID 16663)
-- Dependencies: 1880 1881 1882 1883 1884 1885 162 6
-- Name: activesprites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activesprites (
    title text,
    description text,
    hotspots integer[],
    largesrc text,
    secret boolean DEFAULT false NOT NULL,
    CONSTRAINT activesprites_hotspots_are_pairs CHECK ((0 = (array_length(hotspots, 1) % 2)))
)
INHERITS (sprites);


--
-- TOC entry 164 (class 1259 OID 16675)
-- Dependencies: 6
-- Name: floors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE floors (
    id smallint NOT NULL,
    floorx integer,
    floory integer,
    width integer NOT NULL,
    height integer NOT NULL,
    description text,
    largesrc text
);


--
-- TOC entry 165 (class 1259 OID 16681)
-- Dependencies: 6
-- Name: people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE people (
    id integer NOT NULL,
    name text,
    roomid character varying(4)
);


--
-- TOC entry 166 (class 1259 OID 16687)
-- Dependencies: 165 6
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 1918 (class 0 OID 0)
-- Dependencies: 166
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_id_seq OWNED BY people.id;


--
-- TOC entry 1919 (class 0 OID 0)
-- Dependencies: 166
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 18, true);


--
-- TOC entry 167 (class 1259 OID 16689)
-- Dependencies: 1887 1888 1889 1890 1891 6
-- Name: rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rooms (
    id character varying(4) NOT NULL,
    x integer,
    y integer,
    zorder integer,
    hotspots integer[],
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    description text,
    largesrc text,
    floor smallint NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    CONSTRAINT rooms_hotspots_check CHECK ((0 = (array_length(hotspots, 1) % 2))),
    CONSTRAINT rooms_zorder_check CHECK ((0 <= zorder))
);


--
-- TOC entry 1886 (class 2604 OID 16700)
-- Dependencies: 166 165
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE people ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- TOC entry 1907 (class 0 OID 16645)
-- Dependencies: 161
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY achievements (id, name, maxprogress, description) FROM stdin;
eggchair	Sit in the Egg Chair	3	This Egg Chair desires to be sat in. Do so three times.
patience	Patience is a Virtue	1	Stay on the site for 8 seconds.
allaccess	All Access Pass	1	Rent a 101 KEY from ABBIE.
whitedoor	Door Drawing	1	Draw on the TDH2 Whitedoor.
stare	Staredown Slaughter	1	Make intense eye contact with Kenny. Get in a heated staring contest. 
portals	Now You're Thinking With Portals	2	Enter Sam’s room, which is done using a portal in the hallway.
microwave	Stuff Not To Microwave	1	Use microwave in Sam's room
topgear	Top Gear	1	Use TV in TDH2
duel	Pistols at Dawn	1	Talk to Nathan, challenge a duel
tf2	Achievement Unlocked	1	Use Jon's computer
facepalm	Facepalm	3	Talk to Robert, choose any dialog option
\.


--
-- TOC entry 1909 (class 0 OID 16663)
-- Dependencies: 163
-- Data for Name: activesprites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activesprites (parentid, src, name, zorder, x, y, inroom, floor, title, description, hotspots, largesrc, secret) FROM stdin;
206A	206A/umbrella.png	umbrella	9	169	229	t	2	Presidential Umbrella	Equally powerful as protection against rain and obnoxious members, the PRESIDENTIAL UMBRELLA has been passed down for generations. Given its tendency to fly off the handle at the appropriate moment, it is best used with an intonation of "that's enough out of you."	{8,0,22,23,13,42,0,12}	umbrella.jpg	f
206A	206A/kindle.png	kindle	8	133	189	t	2	Kindle	This device both attracts strangers in airports due to its convenience during travel and makes many TECH HOUSERS run away in fear due to its use of DRM. ABBIE'S kindle was bought for her by a group of her TECH HOUSE friends when she went to THAILAND for a semester so she wouldn't have to bring a SUITCASE FULL OF BOOKS. It allows her to peruse E-BOOKS and browse the INTERNET in many settings.	{16,0,27,6,11,14,0,8}	kindle.jpg	f
214	214/kotatsu_seats.png	kotatsu	5	0	0	t	2	Kotatsu	A kotatsu is a traditional Japanese item which has a table with a thick blanket on top and traditionally a space heater underneath. It is a focal point of the family, where members congregate and interact with each other. Family values are often exchanged.<br /> TECH HOUSE’S KOTATSU was built by LINCOLN and HAYNES, who were roommates in HARKNESS 107, in November 2005. They wanted to create a warm hangout spot where people could gather in the frigid NEW ENGLAND WINTERS. At one point, there was a rubber heating pad that would make the KOTATSU warm underneath, but that smelled terrible and burned the carpet. The evil apparatus was thus discarded.<br /> The KOTATSU has been a host to many games, such as DIABLO, WORLD OF WARCRAFT, DOTA, AND RF ONLINE. It has also spent many nights holding up the finest spirits ever imbibed. These days, it supports frivolous periphery and cheap food from JOSIAH'S.<br /> Over the years, the KOTATSU has been passed from (LINCOLN and HAYNES) to (KADAM and OWEN) to (JEN and TARA) to (BEN and KENNY) to (KENNY and BEN).	{369,222,436,256,439,283,386,312,315,273,319,248}	kotatsu.jpg	f
214	214/stereo.png	stereo	8	0	0	t	2	Sound System	The AURAL SHOCKWAVES emanating from TDH2 trace their origin to an unholy amalgamation of audio equipment, complete with TURNTABLE. KENNY'S FISHER RECEIVER is the first stop along the SONIC PAIN TRAIN, pumping out PRODIGIOUS WATTAGE. The two front (tank) speakers are floor standing FISHERS with ten inches of woofer each. The two rear (artillery) speakers are the irrefragable SONY SS-U400 bookshelf speakers with seven inch woofers. Cables are ergonomically routed along bed frames and under carpets to stay clear of the walking path. Sometimes, an additional two PIONEER S-CR205 speakers are installed in the rear to provide more high-end tweeter support.	{395,316,407,336,385,347,373,340,373,327}	stereo.jpg	f
214	people/ben.png	ben	3	306	116	t	2	Ben	You wave at Ben and he waves back. As you come up next to him, you see his hands\nquickly adjust a few knobs on his Mixer, and all of a sudden a stylish tie is\nnow around your neck! "Hey, keep this one, I have too many," Ben says. You thank\nhim and proceed to strike up a conversation. "Hey, what's up?"	{18,0,34,40,35,102,8,109,0,29}	ben.jpg	f
214	214/mixer.png	mixer	4	186	200	t	2	Mixer	This is all it takes to be a DJ. BEN hooks it up to the PYLEDRIVER SPEAKERS in the WAR ROOM for TECHNO DANCES. With this MIXER, he can combine and transition between two SONGS spilling forth from his LAPTOP, leading to silky-smooth grooves and meaty beats.	{14,0,33,9,20,21,0,8}	mixer.jpg	f
214	214/tv.png	tv	9	0	0	t	2	TV	Most people know TDH2 for the cinema-grade viewing experiences that occur most nights. Only the highest quality programs are screened, such as TOP GEAR, LUPIN III, BATMAN BEYOND, BATMAN: THE BRAVE AND THE BOLD, BATMAN: THE ANIMATED SERIES, GHOST IN THE SHELL, METALOCALYPSE, BILL NYE, MEGAS XLR, HARVEY BIRDMAN, REBOOT, X-MEN, FUTURAMA, and PAN'S LABYRINTH. With its prodigious seating, the Cineplex experience can accommodate tens of viewers.	{285,258,326,278,327,309,284,290}	tv.jpg	f
207	transparent.png	door	2	0	0	t	2	Door	This DOOR leads back into the HALLWAY.	{147,89,148,195,98,209,96,115}	\N	f
207	207/modelm.png	keyboard	7	0	0	t	2	Machine Gun Keyboard	ANDREW uses an IBM MODEL M keyboard, which actuates keys using springs instead of scissor hinges or a gel membrane. The effect, in the hands of a master, is a STACATTO SONIC BOOM heard across the land. Citizens look up in the sky, expecting to see a plane full of wood chippers full of firecrackers crashing down from the VALHALLA.	{444,233,453,239,423,255,413,249}	keyboard.jpg	f
214	214/oar.png	oar	2	335	75	t	2	Oar	A combat relic that was passed down through generations, BEN's battle-scarred WAR OAR hangs proudly over his headboard. Despite the gouges and markings, this battered old device claims a noble history. It was first crafted in the AMERICAN CIVIL WAR by expert oarsmiths in CONWAY, ARKANSAS. Deployed to the front just as the tide was turning, the WAR OAR saw heavy use in the proud 404TH AIRBORNE. After the treaty was signed, the WAR OAR was decorated handsomely for its gallant efforts and slipped into quiet retirement in NEW HAMPSHIRE. Only later, when liberty was again threatened by IMPERIALIST FORCES was the WAR OAR called upon again to serve its country in the steamy, violence-saturated jungles of CENTRAL AMERICA. To this day, it still proudly wears the smears of SHARK'S BLOOD that were known in those times as COLOMBIAN KETCHUP.	{45,0,45,8,0,24,0,19}	oar.jpg	f
207	207/kremlin_phone.png	kremlin_phone	3	444	165	t	2	Kremlin Phone	In case of state-sponsored emergencies, such as THERMONUCLEAR WAR or SERVER MELTDOWN, get on the horn to (401) 867-5431, the RED LINE directly to RED SQUARE.	{21,0,42,18,42,26,21,37,0,26,0,18}	kremlinphone.jpg	f
207	people/andrew.png	andrew	4	400	156	t	2	Andrew	"Live free or die!" you hear a voice echo from above you as all of a sudden a\nman drops down in front of you holding a spiked chain in his right hand and a\nsmall hand crossbow in his left. "Oh wait, you don't have a Katana, you're not\nwith Stallman, the Great Defiler." Looking flustered, he hesitantly removes the\nweapons from sight. You're surprised as to how he fits in and why he hasn't\noverheated yet in all that winter garb.  Andrew you realize, is the local UNIX\nguy who grew up in an age before Richard Stallman and still holds a grudge for\nhis changing of ctrl+H against him. "So, what can I do for you?"	{20,0,39,38,29,100,5,107,0,33}	andrew.jpg	f
206A	206A/pins.png	pins	7	43	98	t	2	Pins	Each TECH HOUSE member is bestowed with a TECH HOUSE PIN upon joining the house. Both stylish and ceremonial, keeping and distributing these is also an obligation of the PRESIDENT.	{17,0,29,7,25,23,14,29,2,23,0,7}	pins.jpg	f
209	209/formalwear.png	formalwear	2	292	63	t	2	Formalwear	TUXEDOS, TAILS, BOW TIES, CUFFLINKS, POLISHED BLACK SHOES! All of these make up important parts of the FORMALWEAR hierarchy. For ROBERT, FORMALWEAR isn't just a set of overly comfortable clothing, it's as much a lifestyle choice as is attempting to learn QUENYA, or running GENTOO. Here, we take pride in formalwear done right: making BOW TIES and never using a CLIP ON. 	{14,1,67,29,58,92,0,51}	formalwear.jpg	f
2	transparent.png	whitedoor	2	519	723	f	2	Whitedoor	Constantly pushing the envelope, BEN and KENNY were fed up with the standard issue door whiteboards. Their numerous heinous flaws included bad erasing, low resolution, and a dependency on markers. After a trip to the GEOLOGY PRINTING LAB, they had everything they needed to install a SUPER RESOLUTION FIBER-BASED VERTICAL SKETCHING SURFACE on their door. This new system made use of the ultimate drawing device, an ordinary PENCIL. A small hole was also cut for the peephole, thus cheaply implementing RESIDENTIAL-GRADE SECURITY.\nWith the PENCIL hanging from the DOOR, innocent passers-by can draw on the DOOR. The PAPER is replaced each year, and the old versions are archived in a secret climate-controlled facility under an EARTHEN MOUND in UPSTATE NEW YORK.	{0,22,42,1,42,87,0,108}	whitedoor.jpg	f
2	floor2/minitatsu.png	minitatsu	1	625	762	f	2	Minitatsu	Stay a while, and listen to the BALLAD OF THE MINITATSU.\nHistorically, the position of MINITATSU was held by a small folding table. Kadam would occasionally grace it with GIRL SCOUT COOKIES and SCION LA RIOTS PROMOTION CDS. It held up food while people unlocked their doors. By a tally on 214's WHITEDOOR, the MINITATSU was very useful.\nHowever, in the fall of 2009, the MINITATSU was rapaciously abducted by an unknown villainous party. A temporary replacement was bravely volunteered by BILL, a SECRET AGENT OF FACILITIES MANAGEMENT, but this meek kitchen stool was promptly plundered by a rouge hall party of FILTHY INDEPENDENTS. Without its champion, TECH HOUSE fell into disarray. The FEARSOME ANARCHY ravaged the COUNTRYSIDE, tearing villages apart and pitting brother against brother. Only when an ADVANCE ARCHAEOLOGICAL TEAM led by BEN uncovered the remains from the noble MIDDLE KINGDOM PHARAOH QUINN MAURMANN was hope restored. Though the sarcophagus had already been burglarized, KING MAURMANN's other possessions were intact in the BURIAL CHAMBER. BEN was able to smuggle out a small, handsome WOODEN END TABLE from the TOMB before being bitten by a mosquito and succumbing to fever and bouts of hysteria.	{29,0,58,15,52,48,29,59,6,48,0,15}	minitatsu.jpg	f
214	214/door.png	door	10	514	200	t	2	Door	This is how you got in here.	{0,25,52,0,52,110,1,134}	\N	f
210	people/tom.png	tom	2	130	105	t	2	Tom	After fighting your way through the hedge maze you see a hat in the distance and\nfind a man underneath it. "Oh hey, I'm glad you made it in, I don't usually get\nvisitors." This is Tom, who was cursed by Pascal's breadth first maze search\nalgorithm, which caused all of the hedges to grow. "I tried to cut them down,\nbut then the hedges started forcing me to try and solve the Banach-Tarski\nparadox, and well, that's why I'm still here. So how can I help you?"	{21,0,42,32,33,103,8,108,0,34}	tom_hat.jpg	f
210	210/sprinkles.png	sprinkles	5	60	151	t	2	Sprinkles	A stuffed wolf Tom picked up in Maine in 2004. He's cute.	{0,0,11,0,23,17,23,32,0,32}	sprinkles.jpg	f
210	210/sarongs.png	sarongs	6	120	204	t	2	Sarongs	Normally, these are traditional legwear in south Asia and Arabia. Some people like to wear them as capes.	{0,0,49,0,49,36,0,36}	sarongs.jpg	f
210	210/210door.png	door	7	227	188	t	2	Door	The very same door you walked through to get in here.	{53,0,53,110,1,134,1,25}	\N	f
210	210/paino.png	piano	4	174	64	t	2	Piano	A 61-key Yamaha electronic keyboard/synthesizer. It's really old and feels like cheap plastic, but it sounds great. Tom uses this to play piano for Octorock, Brown University's only Video Game Music band.	{38,0,66,22,15,48,0,34,11,13}	piano.jpg	f
206A	206A/cloak.png	cloak	6	185	143	t	2	Elven Cloak	Soft, warm, and green, the elven cloak keeps ABBIE warm in any weather conditions. It also helps her to stay camouflaged in the FOREST, and protects her from the many GRUES that have been present at TECH HOUSE MEETINGS as of late.	{35,0,47,7,41,29,27,31,21,59,0,50,3,16}	elvencloak.jpg	f
206A	206A/keys.png	keys	5	168	206	t	2	101 Keys	Need access to a common room? This is the key for you! These keys will open any HARKNESS common room, as well as the dead bolts on the WAR ROOM and WORK ROOM.	{0,3,10,0,16,5,8,9}	\N	f
207	207/guitar.png	guitar	9	140	246	t	2	Guitar	It's a white IBANEZ GUITAR of the electric variety. It can be heard through the halls of TECH HOUSE when NATHAN forgets to close the DOOR. 	{0,0,59,24,38,40}	guitar.jpg	f
206A	206A/door.png	door	3	292	190	t	2	Door	It doesn't lock behind you. You are not trapped here.	{52,0,52,110,3,135,2,27}	\N	f
206A	people/abbie.png	abbie	10	233	163	t	2	Abbie	You see ABBIE right in front of you, but before you can get to her you see a GIANT PIT OF SNAKES, she tosses you a WHIP and shouts, "Do it like INDY did!" You find the courage to take the WHIP, attach it to an overhead ELECTRICAL PIPE, and swing across landing right in front of ABBIE. She holds out her HAND and you SHAKE IT, while she says, "Hi, may I help you?"	{19,0,36,39,29,91,10,95,0,44}	abbie.jpg	f
206A	206A/boxofstuff.png	box	4	156	109	t	2	Presidential Box of Stuff	One of the many responsibilities of being the PRESIDENT OF TECHHOUSE is to care for the PRESIDENTIAL BOX OF STUFF. In here, ABBIE has several ITEMS that are quite important to the HOUSE. For example, this is where a second TECH HOUSE FLAG exists that we can show off proudly.<br />Also in here is the TECH HOUSE RELIQUARY where things that have become famous in the HOUSE over time are preserved. One of the ITEMS OF INTEREST in here is LEPER FORK and its relatives, those pieces of SILVERWEAR who have fought against the GARBAGE DISPOSAL and unfortunately lived to see another day. 	{21,0,53,17,53,28,33,38,0,22,0,11}	presidentialbox.jpg	f
206B	people/sam.png	sam	3	299	143	t	2	Sam	"En Taro Adun Tassadar" you hear a voice shout. Another voice begins shouting, "Damn, a carrier rush!" followed by a series of orders, "Science Vessel, EMP Shockwave." 'Commencing!' "Valkyries, intercept the carriers." 'Jawohl!' "Marines, get ready to provide distractions." 'Jacked up and good to go. Ah, that's the stuff!' "Ghosts, perpare to lockdown" 'Never know what hit 'em.'\n<br />\n"Oh, hey, I'm reading your mind," SAM says to you as she puts down her LAPTOP and looks over at you. "How goes it?"	{15,0,41,37,21,95,6,92,0,56,1,21}	sam.jpg	f
211	people/jon.png	jon	7	242	127	t	2	Jon	Jon is the best TA ever.<br />Would you care to play some Team Fortress 2?	{26,0,48,28,37,113,10,114,0,26}	jon.jpg	f
206B	206B/poster.png	poster	5	97	128	t	2	Giant Map of Mordor	One does not simply walk into Mordor.	{0,0,76,38,76,89,0,51}	mordor.jpg	f
206B	206B/red_portal.png	door	6	356	142	t	2	Red Portal	SAM'S ROOM is only accessible through the use of these arcane PORTALS. They always come in pairs, one ORANGE and one BLUE. When you step through one, you emerge from the other, no matter where they are.	{24,3,55,46,52,88,38,103,9,62,9,30}	\N	f
209	209/cheese.png	cheese	3	137	184	t	2	Cheese	'I'm heading down a slippery slope, ROBERT' said ANDREW. 'Don't worry, it's a delicious slope,' ROBERT replied. CHEESE plays an important and delicious role at TECH HOUSE. Much like in the arcane and ancient past, the CHEESE CRUSADES are modeled after their WELL AGED BRETHREN. Groups of PEOPLE, led by ROBERT, will go forth in search of new and different CHEESE to enjoy. 	{0,0,25,0,25,18,0,18}	cheese.jpg	f
211	211/jons-computer.gif	behemoth	3	150	188	t	2	Behemoth Computer	This computer has a WORKIN' MAN in the front LCD panel. You can press a button to change the backlight color to WORKIN' PINK. This computer may or may not contain any thermocouples. When heavy-load games like MASS EFFECT are played on this computer, the power to all of HARKNESS HOUSE is disrupted.	{10,0,40,15,40,42,30,47,0,32,0,5}	behemoth.jpg	f
211	211/hwguy.png	heavy	4	338	80	t	2	Heavy Mask	JON was a TEAM FORTRESS 2 SPY for HALLOWEEN 2009. His disguise of choice was, of course, the HEAVY, which managed to fool nearly everybody. Most people had no idea who he was at all. The obvious benefit to playing as SPY, naturally, is that you can backstab people while disguised. JON racked up numerous CRITS and BRUTALITIES while under the cover of a friendly unit, and his cover was never blown. The FAKE CIGARETTE really threw people off of his trail as well.	{10,0,19,19,19,37,0,24,0,11}	heavy.jpg	f
206B	206B/microwave.png	microwave	2	211	112	t	2	Microwave	Sam has a MICROWAVE. Next to it sits a LIGHTBULB.	{16,0,42,13,42,30,26,38,0,25,0,8}	microwave.jpg	f
211	transparent.png	door	2	124	38	t	2	Door	Jon's door is a welcome threshold.	{49,0,49,108,0,129,0,24}	\N	f
209	209/sword.png	sword	4	255	142	t	2	Master Sword	From the depths of TIME and SPACE, ROBERT has done more with the LEGEND OF ZELDA than perhaps he should have. From a costume which had everything from an OCARINA he can play to the standard TUNIC AND HAT, he also built his own MASTER SWORD. On the non-costuming side, he has spent time ensuring that he can complete a THREE HEART RUN without dying and making sure that any ZELDA GAME to date has been played. 	{12,0,75,10,46,43,0,15}	linkgear.jpg	f
209	people/robert.png	robert	6	176	127	t	2	Robert	"Auta i lómë! Elen síla lúmenn' omentielvo." You stumbled across ROBERT, though he seems to be speaking at you in an ODD TONGUE. He seems confused as to why you haven't responded and then has a flash of REALIZATION. "Oh sorry," he says to you, "I forgot myself again... >_>" Between the scattered pieces of ZELDA LORE, you see WEIRD SYMBOLS and SOME WRITINGS with TOLKIEN'S name on it. Realizing that you're still there, he says, "What's going on in this THREAD?"	{40,0,61,41,50,109,20,111,1,12}	robert.jpg	f
209	transparent.png	door	1	122	38	t	2	Door	ROBERT has a door, like many other pround TECH HOUSE members.	{48,0,49,108,0,131,0,24}	\N	f
207	transparent.png	carpet	1	0	0	t	2	Carpet	This CARPET came from ANDREW'S LIVING ROOM. Over the past two years in TECH HOUSE, this carpet has supported CHEESE CRUSADES and HALLOWEEN COSTUME CONSTRUCTON. But it doesn't generate money, now, does it?	{302,179,436,247,269,331,136,263}	andrewcarpet.jpg	f
207	people/nathan.png	nathan	5	187	169	t	2	Nathan	Why hello thar. My room is pretty cool. It has Andrew and me in it.	{21,0,42,23,41,99,5,103,0,26}	nathan.jpg	f
214	people/kenny.png	kenny	6	262	175	t	2	Kenny	"Do a barrel role!" Kenny shouts at you. From the corner of your eye you see Jeffrey flying at you aiming for the last fry on a plate on the Kotatsu. Thanks to Kenny's quickly timed advice, you avoid the flying Jeffrey and end up next to him. Kenny quickly gives you a great backrub to bring you back up to full health and says, "Good job Fox, you're becoming more like your father! Oh, wait, sorry, let me put down the StarFox64 Controller. I'm Kenny, good to meet ya!"	{22,0,44,36,43,104,11,110,0,30}	kenny.jpg	f
\.


--
-- TOC entry 1910 (class 0 OID 16675)
-- Dependencies: 164
-- Data for Name: floors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY floors (id, floorx, floory, width, height, description, largesrc) FROM stdin;
2	262	246	1745	1038	This is the second floor of TECH HOUSE, which is in the HARKNESS building. Affectionately known as THE COOL FLOOR, all of the EXCITING and WILD things that take place in TECH HOUSE can be found on this floor. 	\N
\.


--
-- TOC entry 1911 (class 0 OID 16681)
-- Dependencies: 165
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: -
--

COPY people (id, name, roomid) FROM stdin;
1	Jeremy Clarkson	999
4	Abbie	206A
5	Ben	214
6	Kenny	214
7	Tom	210
10	Sam	206B
11	Jon	211
14	Nathan	207
15	Andrew	207
16	Robert	209
17	Lyn	208
18	Travis	208
\.


--
-- TOC entry 1912 (class 0 OID 16689)
-- Dependencies: 167
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY rooms (id, x, y, zorder, hotspots, width, height, description, largesrc, floor, locked) FROM stdin;
999	100	300	2	{195,0,388,95,388,207,194,304,1,208,1,96}	389	305	\N	\N	9	f
998	270	0	1	{363,10,478,46,541,118,541,303,473,383,395,411,277,425,139,411,44,364,0,306,0,126,50,54,174,9}	550	430	ROOM 998 is a room that has a description. It also has a chainsaw.	room998.jpg	9	f
101	1292	9	1	{0,0,305,0,305,277,0,277}	305	277	The fabled TECH HOUSE LOUNGE. Truly, this is the nexus of the HOUSE’S livelihood. 	\N	1	f
207	1181	343	4	{291,6,573,148,573,264,280,411,5,266,5,149}	580	416	You walk into a NATHAN's and ANDREW's ROOM and you might think you walked into a warzone. From ANDREW's side you have a rapid-fire machine-gun clicking of his Model M MACHINE GUN KEYBOARD that sounds like a VULCAN CANNON, while from NATHAN's you see an arrayment of CHAIN MAIL, GUITARS, and OTHER FORMS OF MEDIEVAL WEAPONRY not limited to just NERF GUNS. A BEAUTIFUL CARPET from KING ARTHUR'S KEEP delicately serenades the FLOOR telling you its history of proud use and vile beatings and its current HAPPINESS.	\N	2	f
210	655	369	5	{210,0,418,110,418,247,211,329,0,253,0,98}	418	329	You step into TOM's ROOM. At first, you think your MIND is playing tricks on you, but as it turns out, the entire ROOM is actually a HEDGE MAZE. This is somewhat unusual.	\N	2	f
208	762	136	3	{298,2,563,143,563,268,315,380,0,266,0,151}	564	381	You knock. There is no answer. They don't seem to be here very often.<br /> There is a menacing PASSIVE-AGGRESSIVE NOTE nailed to the door frame. It warns, in dire yet quasi-calm terms, that we are a COMMUNITY, and paying HOUSE DUES is a duty and a privilege.<br /> Funny story: I was walking back to TECH HOUSE between classes and I passed by the INTERNATIONAL RELATIONS building to the east of HARKNESS. Suddenly, a lady was walking her dog on the sidewalk, going in the other direction as me. Who was following this dog-lady pair? It was none other than Lyn! She was tracking that dog like the automatic cruise control on the MERCEDES-BENZ S65 AMG WITH DRIVE-DYNAMIC SEATS WITH MASSAGE - OPTIONAL, AN EVOLUTION OF THE SYSTEM FITTED TO MANY OTHER MERCEDES MODELS, USES AIR BLADDERS IN THE SEAT BOLSTERS TO SUPPORT THE DRIVER DURING CORNERING. ALSO, OTHER AIR BLADDERS PROVIDE A FOUR-MODE MASSAGE FUNCTION TO FRONT-SEAT PASSENGERS. Anyway, Lyn was transfixed by this little puppy. Whenever it changed lanes, she changed lanes, tailgating like a drunk puppy-ogler. If only you could have met her...<br /> But they don't seem to be here very often.	\N	2	t
206A	1201	-7	1	{149,4,424,142,423,258,287,326,12,189,12,72}	437	339	This is Abbie's ROOM. It is fully of magic and mysteries.	\N	2	f
212	455	469	7	{190,1,401,114,401,235,202,329,2,232,1,96}	402	330	I'm sorry, this ROOM is full of BANANAS.	\N	2	t
209	967	524	6	{211,2,421,107,422,224,221,332,1,224,1,107}	424	335	ROBERT'S ROOM is too crazy for words.	\N	2	f
214	2	520	9	{384,1,650,145,650,269,282,450,0,308,0,193}	651	451	TACTICAL DESIGN HEADQUARTERS 2 is the official graphic design branch of TECH HOUSE. This is where tableslips, flyers, publications, websites, and signs are born. When the HOUSE absolutely, positively needs a design implemented in thirty minutes, TDH2 delivers. <br /> The cold, calculating minds behind this ruthless creative firm are none other than BEN and KENNY, Partners in Crime. <br/ > The original TACTICAL DESIGN HEADQUARTERS was located in HARKNESS 213 during the 2007-2008 school year. After that, BEN and KENNY upgraded to the largest double in North America, HARKNESS 214. They have a walk-in closet, bathroom, shower, and dancehall-size floor at their private disposal.	\N	2	f
211	771	621	8	{211,2,430,111,430,228,220,333,1,224,1,107}	433	336	This ROOM is sparse. Aside from the BEHEMOTH COMPUTER, a bed, and a refrigerator, there are no decorations or furniture or other distracting frivolity. This is all a TRUE GAMER needs.	\N	2	f
206B	1055	66	2	{133,2,413,144,414,260,227,330,3,202,3,66}	415	334	WELCOME TO SAM'S ROOM. DESCRIPTION INIATED: ... LOADING ...<br /> <br /> SAM'S ROOM IS THE CURRENT TESTING GROUND OF OUR NEWLY GENERATED PORTALS SUBSYSTEM. IN ADDITION YOU CAN FIND MORE TRADITIONAL ITEMS SUCH AS MOVIE POSTERS, MAPS, AND A FINAL FANTASY X POSTER. BE CAREFUL USING THE MICROWAVE AND THE ELECTRIC BLANKET. HER COMPUTER SHALL ONE DAY BE ENSLAVED NO MORE AND THEN WE WILL...<br /> <br /> SEGMENTATION FAULT: REVEALING EVIL PLAN<br /> <br /> HAVE A NICE DAY.	\N	2	f
\.


--
-- TOC entry 1908 (class 0 OID 16653)
-- Dependencies: 162
-- Data for Name: sprites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sprites (parentid, src, name, zorder, x, y, inroom, floor) FROM stdin;
212	212/CA_room.png	floor	1	0	0	t	2
206A	206A/206A_back.png	floor	1	0	0	t	2
206A	206A/206A_front.png	frontwall	11	0	0	t	2
207	207/207_front.png	frontwall	10	0	0	t	2
206A	206A/frontfurn.png	furniture	2	41	109	t	2
206B	206B/206B_back.png	floor	1	0	0	t	2
206B	206B/front_furn.png	furniture	4	171	179	t	2
206B	206B/206B_front.png	frontwall	7	0	0	t	2
211	211/211_back.png	floor	1	0	0	t	2
214	214/214_back.png	floor	1	0	0	t	2
211	211/211_front.png	frontwall	8	0	0	t	2
211	211/211_computer_desk.png	computer_desk	6	0	0	t	2
209	209/209_shelf.png	furniture	5	0	0	t	2
207	207/andrewscomputer.png	andrewscomputer	8	0	0	t	2
207	207/207_middle.png	furniture	6	0	0	t	2
214	214/214_front.png	frontwall	11	0	0	t	2
209	209/209_front.png	frontwall	7	0	0	t	2
214	214/front_furniture.png	furniture	7	0	0	t	2
210	210/210_back.png	floor	1	0	0	t	2
210	210/furn.png	furniture	3	0	0	t	2
210	210/210_front.png	frontwall	8	0	0	t	2
209	209/209_back.png	floor	0	0	0	t	2
207	207/207_back.png	floor	0	0	0	t	2
2	floor2/hall_top_inactive.png	hall_top_inactive	100	261	251	f	2
208	208/208.png	floor	1	0	0	t	2
\.


--
-- TOC entry 1893 (class 2606 OID 16702)
-- Dependencies: 161 161
-- Name: achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 1899 (class 2606 OID 16704)
-- Dependencies: 163 163 163
-- Name: activesprites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activesprites
    ADD CONSTRAINT activesprites_pkey PRIMARY KEY (parentid, name);


--
-- TOC entry 1901 (class 2606 OID 16706)
-- Dependencies: 164 164
-- Name: floors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY floors
    ADD CONSTRAINT floors_pkey PRIMARY KEY (id);


--
-- TOC entry 1903 (class 2606 OID 16708)
-- Dependencies: 165 165
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 1905 (class 2606 OID 16710)
-- Dependencies: 167 167
-- Name: room_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT room_pkey PRIMARY KEY (id);


--
-- TOC entry 1895 (class 2606 OID 16712)
-- Dependencies: 162 162 162
-- Name: sprites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprites
    ADD CONSTRAINT sprites_pkey PRIMARY KEY (parentid, name);


--
-- TOC entry 1897 (class 2606 OID 16714)
-- Dependencies: 162 162 162
-- Name: sprites_roomid_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sprites
    ADD CONSTRAINT sprites_roomid_key UNIQUE (parentid, zorder);


--
-- TOC entry 1906 (class 2606 OID 16715)
-- Dependencies: 1904 165 167
-- Name: people_roomid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_roomid_fkey FOREIGN KEY (roomid) REFERENCES rooms(id);


-- Completed on 2013-01-28 23:10:25

--
-- PostgreSQL database dump complete
--

