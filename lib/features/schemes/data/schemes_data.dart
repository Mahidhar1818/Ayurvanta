import '../models/health_scheme_model.dart';

// ── Central Government Schemes (available in ALL states) ──
const List<HealthScheme> centralSchemes = [
  HealthScheme(
    name: 'Ayushman Bharat PM-JAY',
    description:
        'Free health coverage up to ₹5 lakh per family per year for secondary & tertiary hospitalisation. Covers 10.74 crore poor families. Now extended to all citizens aged 70+.',
    coverage: '₹5 lakh/family/year',
    eligibility: 'Bottom 40% of population (SECC 2011). All citizens 70+ years.',
    officialUrl: 'https://pmjay.gov.in',
    type: 'central',
    category: 'Health Insurance',
  ),
  HealthScheme(
    name: 'CGHS – Central Govt Health Scheme',
    description:
        'Comprehensive healthcare for central government employees, pensioners & MPs. Operates through wellness centres in 70+ cities.',
    coverage: 'Outpatient, specialist, diagnostics, hospitalisation',
    eligibility: 'Central govt employees, pensioners, MPs & dependants',
    officialUrl: 'https://cghs.gov.in',
    type: 'central',
    category: 'Govt Employee',
  ),
  HealthScheme(
    name: 'National Health Mission (NHM)',
    description:
        'Free drugs, diagnostics, blood, diet & transport at all public health facilities. Covers RMNCH+A, RBSK newborn screening, dialysis & mobile medical units.',
    coverage: 'Free at all government hospitals',
    eligibility: 'All income groups at public health facilities',
    officialUrl: 'https://nhm.gov.in',
    type: 'central',
    category: 'Primary Healthcare',
  ),
  HealthScheme(
    name: 'Pradhan Mantri Suraksha Bima Yojana',
    description:
        'Accidental death and disability insurance at just ₹12/year premium. Worldwide coverage.',
    coverage: '₹2 lakh (accidental death/total disability), ₹1 lakh (partial)',
    eligibility: 'Age 18–70 with bank account',
    officialUrl: 'https://jansuraksha.gov.in',
    type: 'central',
    category: 'Accident Insurance',
  ),
  HealthScheme(
    name: 'ESI – Employees State Insurance',
    description:
        'Health & social security for organised sector workers. Covers medical care for employees and families at ESI hospitals and dispensaries.',
    coverage: 'Full medical care + cash benefits',
    eligibility: 'Employees earning ≤₹21,000/month in registered establishments',
    officialUrl: 'https://esic.gov.in',
    type: 'central',
    category: 'Employee Insurance',
  ),
  HealthScheme(
    name: 'Janani Suraksha Yojana (JSY)',
    description:
        'Cash assistance to pregnant women for institutional delivery. Reduces maternal and infant mortality.',
    coverage: '₹1,400 (rural), ₹1,000 (urban) cash benefit',
    eligibility: 'BPL pregnant women, SC/ST women of any income',
    officialUrl: 'https://nhm.gov.in/index4.php?lang=1&level=0&linkid=62&lid=221',
    type: 'central',
    category: 'Maternal Health',
  ),
  HealthScheme(
    name: 'Ayushman Bharat Digital Mission',
    description:
        'Creates digital health IDs (ABHA) linking all health records across India. Enables paperless healthcare.',
    coverage: 'Digital health records, interoperability',
    eligibility: 'All Indian citizens',
    officialUrl: 'https://abdm.gov.in',
    type: 'central',
    category: 'Digital Health',
  ),
];

// ── State-wise Schemes ──────────────────────────────────
const Map<String, StateSchemeData> stateSchemes = {
  'Andhra Pradesh': StateSchemeData(
    state: 'Andhra Pradesh',
    stateCode: 'AP',
    schemes: [
      HealthScheme(
        name: 'Dr YSR Aarogyasri',
        description:
            'Free treatment for BPL families at empanelled govt & private hospitals. Covers 2,448 medical procedures including surgeries, therapies & follow-up care.',
        coverage: '₹2.5 lakh/family (BPL) + ₹25 lakh critical',
        eligibility: 'White ration card holders (BPL families)',
        officialUrl: 'https://aarogyasri.ap.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'EHS – Employee Health Scheme (AP)',
        description:
            'Cashless medical treatment for state govt employees, pensioners & dependants at empanelled hospitals across AP.',
        coverage: 'Cashless treatment, no limit for critical care',
        eligibility: 'AP state govt employees & pensioners',
        officialUrl: 'https://ehs.ap.gov.in',
        type: 'state',
        category: 'Govt Employee',
      ),
      HealthScheme(
        name: 'NTR Vaidya Seva',
        description:
            'Universal health coverage combining PM-JAY and Aarogyasri for broader population coverage. Approved Sept 2025.',
        coverage: '₹2–5 lakh coverage based on income',
        eligibility: 'All AP residents based on income criteria',
        officialUrl: 'https://health.ap.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Telangana': StateSchemeData(
    state: 'Telangana',
    stateCode: 'TS',
    schemes: [
      HealthScheme(
        name: 'Rajiv Aarogyasri (Cheyutha)',
        description:
            'Free medical and healthcare up to ₹10 lakh for economically backward sections. Launched by CM Revanth Reddy. Covers corporate medical treatment at empanelled hospitals.',
        coverage: '₹10 lakh free treatment',
        eligibility: 'Economically backward sections (white ration card)',
        officialUrl: 'https://www.telangana.gov.in/government-initiatives',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'TS Employees & Journalists Health Scheme',
        description:
            'Cashless medical treatment for Telangana state employees, pensioners and working journalists at empanelled hospitals.',
        coverage: 'Cashless treatment at network hospitals',
        eligibility: 'TS state employees, pensioners & journalists',
        officialUrl: 'https://ehs.telangana.gov.in',
        type: 'state',
        category: 'Govt Employee',
      ),
      HealthScheme(
        name: 'KCR Kit – Kalyana Lakshmi',
        description:
            'Maternity benefit scheme providing delivery kits, nutrition and cash assistance to pregnant women in Telangana.',
        coverage: '₹12,000 cash + delivery kit',
        eligibility: 'Pregnant women in Telangana',
        officialUrl: 'https://wdcw.telangana.gov.in',
        type: 'state',
        category: 'Maternal Health',
      ),
    ],
  ),

  'Tamil Nadu': StateSchemeData(
    state: 'Tamil Nadu',
    stateCode: 'TN',
    schemes: [
      HealthScheme(
        name: 'Chief Minister\'s Comprehensive Health Insurance Scheme (CMCHIS)',
        description:
            'Family floater health insurance covering 1,000+ procedures at select govt & private hospitals. Promoted with United India Insurance Company.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'TN residents earning < ₹72,000/year',
        officialUrl: 'https://www.cmchistn.com',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'TN Chief Minister\'s Cancer Relief Fund',
        description:
            'Financial assistance for cancer treatment at government hospitals in Tamil Nadu. Covers chemotherapy, radiation and surgeries.',
        coverage: 'Up to ₹1.5 lakh for cancer treatment',
        eligibility: 'BPL cancer patients in Tamil Nadu',
        officialUrl: 'https://www.tnhealth.tn.gov.in',
        type: 'state',
        category: 'Cancer Care',
      ),
      HealthScheme(
        name: 'Muthulakshmi Reddy Maternity Benefit Scheme',
        description:
            'Cash assistance and nutrition support for pregnant women to encourage institutional delivery and reduce maternal mortality.',
        coverage: '₹18,000 cash in instalments',
        eligibility: 'Pregnant women below poverty line in TN',
        officialUrl: 'https://www.tnhealth.tn.gov.in',
        type: 'state',
        category: 'Maternal Health',
      ),
    ],
  ),

  'Karnataka': StateSchemeData(
    state: 'Karnataka',
    stateCode: 'KA',
    schemes: [
      HealthScheme(
        name: 'Ayushman Bharat – Arogya Karnataka',
        description:
            'Karnataka\'s integration of PM-JAY with state scheme. Universal health coverage for all residents with enhanced benefits for BPL families.',
        coverage: '₹5 lakh (APL), ₹10 lakh (BPL)',
        eligibility: 'All Karnataka residents; enhanced for BPL',
        officialUrl: 'https://arogya.karnataka.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'Yeshasvini Health Insurance Scheme',
        description:
            'Cooperative-based health scheme for rural cooperative members. Low-cost premium with access to 800+ surgeries at network hospitals.',
        coverage: '800+ surgical procedures',
        eligibility: 'Karnataka cooperative society members',
        officialUrl: 'https://www.yeshasvini.kar.nic.in',
        type: 'state',
        category: 'Cooperative Insurance',
      ),
      HealthScheme(
        name: 'Karnataka Rajiv Arogya Bhagya',
        description:
            'Free OPD and IPD services at all government hospitals in Karnataka for all residents regardless of income.',
        coverage: 'Free at all govt hospitals',
        eligibility: 'All Karnataka residents',
        officialUrl: 'https://arogya.karnataka.gov.in',
        type: 'state',
        category: 'Free Healthcare',
      ),
    ],
  ),

  'Kerala': StateSchemeData(
    state: 'Kerala',
    stateCode: 'KL',
    schemes: [
      HealthScheme(
        name: 'Karunya Health Scheme',
        description:
            'Financial assistance for serious illnesses including cancer, kidney failure and cardiac conditions for BPL families in Kerala.',
        coverage: '₹2 lakh for critical illness',
        eligibility: 'BPL families in Kerala',
        officialUrl: 'https://karunyakeralam.gov.in',
        type: 'state',
        category: 'Critical Illness',
      ),
      HealthScheme(
        name: 'Awaz Health Insurance (Migrant Workers)',
        description:
            'Health insurance for inter-state migrant workers in Kerala. Also covers accidental death. Covers 5 lakh+ migrant labourers.',
        coverage: '₹15,000 health + ₹2 lakh death cover',
        eligibility: 'Inter-state migrant workers aged 18–60 in Kerala',
        officialUrl: 'https://lc.kerala.gov.in',
        type: 'state',
        category: 'Migrant Workers',
      ),
      HealthScheme(
        name: 'MEDISEP – Medical Insurance for State Employees',
        description:
            'Cashless health insurance for Kerala state govt employees, pensioners and family members at empanelled hospitals.',
        coverage: '₹3 lakh/family/year cashless',
        eligibility: 'Kerala state govt employees & pensioners',
        officialUrl: 'https://medisep.kerala.gov.in',
        type: 'state',
        category: 'Govt Employee',
      ),
    ],
  ),

  'Maharashtra': StateSchemeData(
    state: 'Maharashtra',
    stateCode: 'MH',
    schemes: [
      HealthScheme(
        name: 'Mahatma Jyotiba Phule Jan Arogya Yojana',
        description:
            'Health insurance for low-income families. Covers medical, surgical treatments at govt & private hospitals. All pre-existing diseases covered.',
        coverage: '₹1.5 lakh/year + ₹1.5 lakh PM-JAY top-up',
        eligibility: 'Yellow/orange/white ration card holders in MH',
        officialUrl: 'https://www.jeevandayee.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'MH State Government Employees GIS',
        description:
            'Group Insurance Scheme with health benefits for Maharashtra state government employees.',
        coverage: 'Group insurance with health component',
        eligibility: 'Maharashtra state government employees',
        officialUrl: 'https://finance.maharashtra.gov.in',
        type: 'state',
        category: 'Govt Employee',
      ),
    ],
  ),

  'Gujarat': StateSchemeData(
    state: 'Gujarat',
    stateCode: 'GJ',
    schemes: [
      HealthScheme(
        name: 'Mukhyamantri Amrutum (MA) Yojana',
        description:
            'Health insurance for BPL & lower middle-class families. Covers treatment at public, private, trust and grant-in-aid hospitals across Gujarat.',
        coverage: '₹3 lakh/family/year',
        eligibility: 'BPL & lower middle-class families with MA Amrutum card',
        officialUrl: 'https://www.magujarat.com',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'Mukhyamantri Amrutum Vatsalya Yojana',
        description:
            'Extended coverage under MA Yojana for families above BPL but needing financial support for medical care.',
        coverage: '₹2 lakh/family/year',
        eligibility: 'Lower middle-class families in Gujarat',
        officialUrl: 'https://www.magujarat.com',
        type: 'state',
        category: 'Health Insurance',
      ),
    ],
  ),

  'Rajasthan': StateSchemeData(
    state: 'Rajasthan',
    stateCode: 'RJ',
    schemes: [
      HealthScheme(
        name: 'Chiranjeevi Swasthya Bima Yojana',
        description:
            'Universal health coverage for all Rajasthan families. Highest coverage scheme in India at 88% of households. Cashless treatment at 1,200+ hospitals.',
        coverage: '₹10 lakh/family/year (₹25 lakh for critical)',
        eligibility: 'All Rajasthan residents (free for BPL/SECC)',
        officialUrl: 'https://chiranjeevi.rajasthan.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
      HealthScheme(
        name: 'Bhamashah Swasthya Bima Yojana',
        description:
            'Earlier state scheme now merged with Chiranjeevi. Provides cashless services through public & private hospitals.',
        coverage: '₹30,000 (general) + ₹3 lakh (critical)',
        eligibility: 'BPL families in Rajasthan',
        officialUrl: 'https://health.rajasthan.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
    ],
  ),

  'West Bengal': StateSchemeData(
    state: 'West Bengal',
    stateCode: 'WB',
    schemes: [
      HealthScheme(
        name: 'Swasthya Sathi',
        description:
            'Universal health coverage for all WB families. Covers hospitalisation at empanelled govt & private hospitals. Smart card based scheme.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'All West Bengal residents (universal)',
        officialUrl: 'https://swasthyasathi.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Odisha': StateSchemeData(
    state: 'Odisha',
    stateCode: 'OD',
    schemes: [
      HealthScheme(
        name: 'Biju Swasthya Kalyan Yojana (BSKY)',
        description:
            'Universal health coverage for all Odisha families. Women get enhanced ₹10 lakh cover. Smart health card for cashless treatment.',
        coverage: '₹5 lakh (general), ₹10 lakh (women) per year',
        eligibility: 'All Odisha residents (SECC + additional)',
        officialUrl: 'https://bsky.odisha.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
      HealthScheme(
        name: 'Niramaya Health Insurance (Odisha)',
        description:
            'Health insurance for persons with disabilities in Odisha covering hospitalisation and treatment costs.',
        coverage: '₹1 lakh/year for disability-related treatment',
        eligibility: 'Persons with disabilities in Odisha',
        officialUrl: 'https://nhfdc.nic.in/niramaya.html',
        type: 'state',
        category: 'Disability',
      ),
    ],
  ),

  'Punjab': StateSchemeData(
    state: 'Punjab',
    stateCode: 'PB',
    schemes: [
      HealthScheme(
        name: 'Sarbat Sehat Bima Yojana',
        description:
            'Universal health insurance for all Punjab families. Covers hospitalisation at 800+ empanelled hospitals. Issued smart Sehat cards.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'All Punjab residents (2.74 crore beneficiaries)',
        officialUrl: 'https://sha.punjab.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Madhya Pradesh': StateSchemeData(
    state: 'Madhya Pradesh',
    stateCode: 'MP',
    schemes: [
      HealthScheme(
        name: 'Ayushman Bharat – Nirogi MP',
        description:
            'MP\'s enhanced Ayushman Bharat with additional state benefits. Covers treatments at empanelled hospitals across MP.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'SECC-listed families in MP',
        officialUrl: 'https://setu.mp.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'Mukhyamantri Bal Hriday Upchar Yojana',
        description:
            'Free cardiac treatment for children below 15 years in Madhya Pradesh at empanelled hospitals.',
        coverage: 'Free cardiac surgery for children',
        eligibility: 'Children below 15 years in MP with heart disease',
        officialUrl: 'https://health.mp.gov.in',
        type: 'state',
        category: 'Child Health',
      ),
    ],
  ),

  'Uttar Pradesh': StateSchemeData(
    state: 'Uttar Pradesh',
    stateCode: 'UP',
    schemes: [
      HealthScheme(
        name: 'Mukhyamantri Jan Arogya Yojana (UP)',
        description:
            'UP government\'s top-up scheme over PM-JAY. Covers additional beneficiaries not in SECC list. Cashless treatment at empanelled hospitals.',
        coverage: '₹5 lakh/year (additional to PM-JAY)',
        eligibility: 'UP residents not covered under PM-JAY SECC list',
        officialUrl: 'https://shasup.in',
        type: 'state',
        category: 'Health Insurance',
      ),
    ],
  ),

  'Bihar': StateSchemeData(
    state: 'Bihar',
    stateCode: 'BR',
    schemes: [
      HealthScheme(
        name: 'Mukhyamantri Chikitsa Sahayata Kosh',
        description:
            'Financial assistance for serious illness treatment in Bihar. Covers expenses for cancer, kidney, heart and other critical diseases.',
        coverage: 'Up to ₹5 lakh for critical illness',
        eligibility: 'BPL residents of Bihar',
        officialUrl: 'https://state.bihar.gov.in/health',
        type: 'state',
        category: 'Critical Illness',
      ),
    ],
  ),

  'Jharkhand': StateSchemeData(
    state: 'Jharkhand',
    stateCode: 'JH',
    schemes: [
      HealthScheme(
        name: 'Mukhyamantri Swasthya Bima Yojana (Jharkhand)',
        description:
            'Health insurance for BPL families in Jharkhand. Covers treatment at govt & empanelled private hospitals.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'BPL families in Jharkhand',
        officialUrl: 'https://jharkhand.gov.in/health',
        type: 'state',
        category: 'Health Insurance',
      ),
    ],
  ),

  'Assam': StateSchemeData(
    state: 'Assam',
    stateCode: 'AS',
    schemes: [
      HealthScheme(
        name: 'Atal Amrit Abhiyan',
        description:
            'Free treatment for 6 disease categories (cancer, heart, kidney, neuro, burns, neonatology) for BPL families in Assam.',
        coverage: '₹2 lakh/year for 6 critical disease categories',
        eligibility: 'BPL families in Assam (income < ₹5 lakh/year)',
        officialUrl: 'https://atalamritabhiyan.assam.gov.in',
        type: 'state',
        category: 'Critical Illness',
      ),
    ],
  ),

  'Himachal Pradesh': StateSchemeData(
    state: 'Himachal Pradesh',
    stateCode: 'HP',
    schemes: [
      HealthScheme(
        name: 'Him Care Scheme',
        description:
            'Universal health insurance for HP residents not covered under PM-JAY. Cashless treatment at 200+ empanelled hospitals.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'HP residents not covered by PM-JAY/CGHS/ESI',
        officialUrl: 'https://himcare.hp.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Uttarakhand': StateSchemeData(
    state: 'Uttarakhand',
    stateCode: 'UK',
    schemes: [
      HealthScheme(
        name: 'Atal Ayushman Uttarakhand Yojana',
        description:
            'Universal health coverage for all Uttarakhand families. Includes PM-JAY beneficiaries and additional state households.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'All Uttarakhand residents',
        officialUrl: 'https://sha.uk.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Chhattisgarh': StateSchemeData(
    state: 'Chhattisgarh',
    stateCode: 'CG',
    schemes: [
      HealthScheme(
        name: 'Dr. Khubchand Baghel Swasthya Sahayata Yojana',
        description:
            'Universal health coverage for all CG residents. Free treatment at govt & empanelled hospitals. Higher coverage for BPL.',
        coverage: '₹5 lakh (general), ₹20 lakh (BPL)',
        eligibility: 'All Chhattisgarh residents',
        officialUrl: 'https://dkbssy.cg.gov.in',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Goa': StateSchemeData(
    state: 'Goa',
    stateCode: 'GA',
    schemes: [
      HealthScheme(
        name: 'Deen Dayal Swasthya Seva Yojana (DDSY)',
        description:
            'Universal health insurance for all Goa residents. Cashless treatment at empanelled hospitals in Goa.',
        coverage: '₹2.5–4 lakh/family/year',
        eligibility: 'All Goa residents (domicile certificate required)',
        officialUrl: 'https://www.goa.gov.in/health',
        type: 'state',
        category: 'Universal Health',
      ),
    ],
  ),

  'Delhi': StateSchemeData(
    state: 'Delhi',
    stateCode: 'DL',
    schemes: [
      HealthScheme(
        name: 'PM-JAY Delhi (April 2025)',
        description:
            'Delhi signed MoU with NHA in April 2025 to join PM-JAY. All eligible Delhi residents now get ₹5 lakh health coverage.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'SECC-listed Delhi residents',
        officialUrl: 'https://pmjay.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
      HealthScheme(
        name: 'Mohalla Clinic Scheme',
        description:
            'Free primary healthcare including OPD, medicines, and diagnostics at 500+ Mohalla Clinics across Delhi neighbourhoods.',
        coverage: 'Free OPD, 212 medicines, 38 diagnostics',
        eligibility: 'All Delhi residents',
        officialUrl: 'https://health.delhi.gov.in',
        type: 'state',
        category: 'Primary Healthcare',
      ),
    ],
  ),

  'Haryana': StateSchemeData(
    state: 'Haryana',
    stateCode: 'HR',
    schemes: [
      HealthScheme(
        name: 'Chirayu Haryana (Ayushman Bharat)',
        description:
            'Haryana\'s extension of PM-JAY covering additional families above SECC. Cashless treatment at 700+ empanelled hospitals.',
        coverage: '₹5 lakh/family/year',
        eligibility: 'Haryana families with annual income < ₹1.8 lakh',
        officialUrl: 'https://health.haryana.gov.in',
        type: 'state',
        category: 'Health Insurance',
      ),
    ],
  ),
};
