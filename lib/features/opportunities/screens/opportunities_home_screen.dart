import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'opportunities_auth_screen.dart';

// ── Models ────────────────────────────────────────────────
enum JobType { fullTime, partTime, contract, locum, remote, internship }
enum ApplicationStatus { notApplied, applied, shortlisted, rejected }

class JobListing {
  final String id, title, hospital, city, state, department;
  final String salaryDisplay, experience, qualification, postedAgo;
  final JobType jobType;
  final int applicants;
  final bool isVerified, isUrgent, isFeatured, isGovt;
  final String emoji;
  final List<String> skills, responsibilities, perks;
  final String description, applyUrl, contactEmail;
  ApplicationStatus status;
  bool isSaved;

  JobListing({
    required this.id, required this.title, required this.hospital,
    required this.city, required this.state, required this.department,
    required this.salaryDisplay, required this.experience,
    required this.qualification, required this.postedAgo,
    required this.jobType, required this.applicants,
    required this.isVerified, required this.isUrgent,
    required this.isFeatured, required this.isGovt,
    required this.emoji, required this.skills,
    required this.responsibilities, required this.perks,
    required this.description, required this.applyUrl,
    required this.contactEmail,
    this.status = ApplicationStatus.notApplied,
    this.isSaved = false,
  });
}

// ── Jobs data ─────────────────────────────────────────────
List<JobListing> get allJobs => [
  JobListing(id:'j01', title:'Senior Cardiologist', hospital:'Apollo Hospitals',
    city:'Hyderabad', state:'Telangana', department:'Cardiology',
    salaryDisplay:'₹3–8 LPM', experience:'8–12 years',
    qualification:'MD/DM Cardiology', postedAgo:'2 days ago',
    jobType:JobType.fullTime, applicants:47, isVerified:true,
    isUrgent:true, isFeatured:true, isGovt:false, emoji:'❤️',
    skills:['Angiography','Echocardiography','Cardiac Cath','ICU Management','TAVI'],
    description:'Apollo Hospitals seeks an experienced Cardiologist to lead the Cardiac Sciences team in Hyderabad.',
    responsibilities:['Perform angiography and angioplasty','Lead cardiac ICU management','Conduct academic sessions','Participate in MDT meetings','Handle OPD and emergency cases'],
    perks:['₹3–8 LPM CTC','Performance bonus','Apollo health insurance','Research grants','CPD allowance ₹1L/year'],
    applyUrl:'https://apollohospitals.com/careers', contactEmail:'careers.hyd@apollohospitals.com'),

  JobListing(id:'j02', title:'Medical Officer (MBBS)', hospital:'NHM Telangana',
    city:'Hyderabad', state:'Telangana', department:'General Medicine',
    salaryDisplay:'₹72,000/month', experience:'0–2 years',
    qualification:'MBBS', postedAgo:'1 day ago',
    jobType:JobType.contract, applicants:312, isVerified:true,
    isUrgent:true, isFeatured:false, isGovt:true, emoji:'🏥',
    skills:['Primary Care','Emergency Medicine','OPD Management','PHC Operations'],
    description:'NHM Telangana invites MBBS doctors for Medical Officer posts at Primary Health Centers across all districts.',
    responsibilities:['OPD management at PHC','Immunization and maternal care','Disease surveillance','Health education','Medical records maintenance'],
    perks:['₹72,000/month','Govt accommodation','Govt vehicle','Medical allowance','Annual increment'],
    applyUrl:'https://hmfw.telangana.gov.in', contactEmail:'nhm.ts@telangana.gov.in'),

  JobListing(id:'j03', title:'Neurologist', hospital:'AIIMS Hyderabad',
    city:'Hyderabad', state:'Telangana', department:'Neurology',
    salaryDisplay:'₹1.5–2.5 LPM', experience:'5–10 years',
    qualification:'MD/DM Neurology', postedAgo:'5 days ago',
    jobType:JobType.fullTime, applicants:23, isVerified:true,
    isUrgent:false, isFeatured:true, isGovt:true, emoji:'🧠',
    skills:['EEG','EMG/NCS','Stroke Management','Epilepsy','Movement Disorders'],
    description:'AIIMS Hyderabad seeks a Neurologist for clinical and academic duties in a premier government institution.',
    responsibilities:['OPD and IPD neurology care','Perform EEG and EMG procedures','Teach MBBS and MD students','Clinical research','Emergency consultations'],
    perks:['₹1.5–2.5 LPM (7th CPC)','CGHS healthcare','HRA and TA','Research funding','Academic allowances'],
    applyUrl:'https://aiimsexams.ac.in', contactEmail:'recruitment@aiimshyd.edu.in'),

  JobListing(id:'j04', title:'General Surgeon', hospital:'Yashoda Hospitals',
    city:'Secunderabad', state:'Telangana', department:'Surgery',
    salaryDisplay:'₹2–5 LPM', experience:'5–8 years',
    qualification:'MS General Surgery', postedAgo:'3 days ago',
    jobType:JobType.fullTime, applicants:67, isVerified:true,
    isUrgent:false, isFeatured:false, isGovt:false, emoji:'🔪',
    skills:['Laparoscopic Surgery','Emergency Surgery','Colorectal','Trauma','Hernia Repair'],
    description:'Yashoda Hospitals requires a skilled General Surgeon with strong laparoscopic expertise for their busy surgical unit.',
    responsibilities:['Perform elective and emergency surgeries','Pre/post-operative care','Manage surgical OPD','Train junior residents'],
    perks:['₹2–5 LPM','Surgical procedure incentives','Health insurance','30 days annual leave'],
    applyUrl:'https://yashodahospitals.com/careers', contactEmail:'hr@yashodahospitals.com'),

  JobListing(id:'j05', title:'Radiologist (Teleradiology)', hospital:'MedGenome Labs',
    city:'Remote', state:'Pan India', department:'Radiology',
    salaryDisplay:'₹1.5–4 LPM', experience:'3–8 years',
    qualification:'MD Radiology / DNB', postedAgo:'4 days ago',
    jobType:JobType.remote, applicants:89, isVerified:true,
    isUrgent:false, isFeatured:true, isGovt:false, emoji:'📡',
    skills:['CT Reporting','MRI Reporting','Chest X-Ray','PACS/RIS','Teleradiology'],
    description:'Work from home reporting CT, MRI, and X-rays for hospitals across India. Flexible shift-based.',
    responsibilities:['Report CT/MRI/X-ray remotely','Meet 30–40 reports daily TAT','Quality check junior reports','Emergency radiology on-call'],
    perks:['₹1.5–4 LPM + per-report incentive','Work from home','Flexible shifts','Workstation provided'],
    applyUrl:'https://medgenome.com/careers', contactEmail:'teleradiology@medgenome.com'),

  JobListing(id:'j06', title:'ICU Staff Nurse (Senior)', hospital:'Fortis Healthcare',
    city:'Chennai', state:'Tamil Nadu', department:'Critical Care',
    salaryDisplay:'₹45,000–75,000/month', experience:'3–6 years',
    qualification:'BSc Nursing / GNM', postedAgo:'2 days ago',
    jobType:JobType.fullTime, applicants:234, isVerified:true,
    isUrgent:true, isFeatured:false, isGovt:false, emoji:'👩⚕️',
    skills:['ICU Monitoring','Ventilator Management','ACLS','IV Therapy','Central Line Care'],
    description:'Fortis Malar Hospital Chennai is hiring experienced ICU nurses for Level 3 Critical Care Unit.',
    responsibilities:['1:2 nurse-patient ratio in ICU','Ventilator management','Hemodynamic monitoring','Medication administration'],
    perks:['₹45–75K/month','Night duty allowance ₹5,000','PF + ESI','Uniform + meals'],
    applyUrl:'https://fortishealthcare.com/careers', contactEmail:'nursing.chennai@fortishealthcare.com'),

  JobListing(id:'j07', title:'Staff Nurse – NHM (Fresher)', hospital:'NHM Maharashtra',
    city:'Pune', state:'Maharashtra', department:'Community Health',
    salaryDisplay:'₹18,000–25,000/month', experience:'Fresher',
    qualification:'ANM / GNM / BSc Nursing', postedAgo:'3 days ago',
    jobType:JobType.contract, applicants:1243, isVerified:true,
    isUrgent:true, isFeatured:false, isGovt:true, emoji:'🤱',
    skills:['Maternal Care','Immunization','Health Education','PHC Operations'],
    description:'NHM Maharashtra recruiting ANM and Staff Nurses for Primary Health Centers. Freshers welcome.',
    responsibilities:['Antenatal and postnatal care','Child immunization','Maternal health programs','ASHA coordination'],
    perks:['₹18–25K/month','2-year renewable contract','ESI health cover','Training provided'],
    applyUrl:'https://nrhm.gov.in', contactEmail:'nhm.mh@maharashtra.gov.in'),

  JobListing(id:'j08', title:'Clinical Pharmacist', hospital:'Manipal Hospitals',
    city:'Bengaluru', state:'Karnataka', department:'Pharmacy',
    salaryDisplay:'₹40,000–65,000/month', experience:'2–5 years',
    qualification:'M.Pharm / PharmD', postedAgo:'4 days ago',
    jobType:JobType.fullTime, applicants:92, isVerified:true,
    isUrgent:false, isFeatured:false, isGovt:false, emoji:'💊',
    skills:['Drug Interaction Checking','TDM','Antibiotic Stewardship','Clinical Rounds','Pharmacovigilance'],
    description:'Manipal Hospitals Bengaluru requires a Clinical Pharmacist for medication therapy management alongside physicians.',
    responsibilities:['Clinical rounds participation','Prescription drug-interaction review','TDM monitoring','Patient counseling','ADR reporting'],
    perks:['₹40–65K/month','Annual conference allowance','Health insurance','Learning budget'],
    applyUrl:'https://manipalhospitals.com/careers', contactEmail:'pharmacy.blr@manipalhospitals.com'),

  JobListing(id:'j09', title:'Pharmacist – Retail (Fresher)', hospital:'Apollo Pharmacy',
    city:'Multiple Cities', state:'Pan India', department:'Retail Pharmacy',
    salaryDisplay:'₹22,000–38,000/month', experience:'0–3 years',
    qualification:'B.Pharm / D.Pharm', postedAgo:'1 day ago',
    jobType:JobType.fullTime, applicants:2341, isVerified:true,
    isUrgent:true, isFeatured:false, isGovt:false, emoji:'🏪',
    skills:['Dispensing','Stock Management','Patient Counseling','Billing'],
    description:'Apollo Pharmacy, India\'s largest chain with 3000+ outlets, hiring pharmacists nationwide. Freshers welcome.',
    responsibilities:['Accurate medicine dispensing','Patient counseling','Inventory management','Insurance billing'],
    perks:['₹22–38K/month','PF + ESIC','30% employee discount','Health insurance'],
    applyUrl:'https://apollopharmacy.in/careers', contactEmail:'pharmacist.hiring@apollopharmacy.in'),

  JobListing(id:'j10', title:'Senior Lab Technician', hospital:'SRL Diagnostics',
    city:'Mumbai', state:'Maharashtra', department:'Pathology',
    salaryDisplay:'₹28,000–45,000/month', experience:'3–6 years',
    qualification:'DMLT / BMLT', postedAgo:'5 days ago',
    jobType:JobType.fullTime, applicants:156, isVerified:true,
    isUrgent:false, isFeatured:false, isGovt:false, emoji:'🔬',
    skills:['Hematology','Biochemistry','Microbiology','Histopathology','NABL QC'],
    description:'SRL Diagnostics, India\'s largest diagnostics chain, hiring senior lab technicians for Mumbai reference laboratory.',
    responsibilities:['Perform clinical laboratory tests','Operate automated analyzers','QC monitoring','Report critical values','Maintain NABL standards'],
    perks:['₹28–45K/month','NABL-accredited lab','Annual increment','PF + ESI'],
    applyUrl:'https://srldiagnostics.com/careers', contactEmail:'lab.hiring@srlworld.com'),

  JobListing(id:'j11', title:'Physiotherapist (Neuro Rehab)', hospital:'Kokilaben Hospital',
    city:'Mumbai', state:'Maharashtra', department:'Rehabilitation',
    salaryDisplay:'₹35,000–60,000/month', experience:'2–5 years',
    qualification:'BPT / MPT (Neuro)', postedAgo:'3 days ago',
    jobType:JobType.fullTime, applicants:43, isVerified:true,
    isUrgent:false, isFeatured:false, isGovt:false, emoji:'🏃',
    skills:['Neurological Rehab','Stroke Rehab','Gait Training','Bobath Technique','FIM Scoring'],
    description:'Kokilaben Ambani Hospital seeks a Neuro Physiotherapist for their comprehensive stroke and rehabilitation unit.',
    responsibilities:['Neurological physio for stroke, TBI, SCI patients','Gait training and balance therapy','FIM assessment','Family education'],
    perks:['₹35–60K/month','Level 1 trauma centre exposure','CPD allowance','Health insurance'],
    applyUrl:'https://kokilabenhospital.com/careers', contactEmail:'physio.hiring@kokilabenhospital.com'),

  JobListing(id:'j12', title:'Hospital Administrator', hospital:'Aster DM Healthcare',
    city:'Kochi', state:'Kerala', department:'Administration',
    salaryDisplay:'₹80,000–1.5 LPM', experience:'5–8 years',
    qualification:'MHA / MBA (Healthcare)', postedAgo:'1 week ago',
    jobType:JobType.fullTime, applicants:34, isVerified:true,
    isUrgent:false, isFeatured:true, isGovt:false, emoji:'🏛️',
    skills:['Hospital Operations','JCI Accreditation','Revenue Cycle','HR Management','Quality Improvement'],
    description:'Aster DM Healthcare requires an experienced Hospital Administrator for a 300-bed facility in Kochi.',
    responsibilities:['Day-to-day hospital operations','Budget and financial oversight','JCI/NABH accreditation','Staff recruitment','Patient satisfaction'],
    perks:['₹80K–1.5 LPM','Senior leadership exposure','Stock options eligible','Relocation allowance'],
    applyUrl:'https://asterhospitals.in/careers', contactEmail:'admin.hiring@asterhospitals.in'),

  JobListing(id:'j13', title:'Healthcare Data Analyst', hospital:'Practo',
    city:'Bengaluru', state:'Karnataka', department:'Healthcare IT',
    salaryDisplay:'₹8–18 LPA', experience:'2–5 years',
    qualification:'B.Tech / MBBS + Data Skills', postedAgo:'2 days ago',
    jobType:JobType.fullTime, applicants:287, isVerified:true,
    isUrgent:false, isFeatured:true, isGovt:false, emoji:'💻',
    skills:['Python','SQL','Healthcare Analytics','Power BI','FHIR/HL7','Clinical Data'],
    description:'Practo, India\'s largest healthcare platform, seeks Healthcare Data Analysts to drive insights from clinical data.',
    responsibilities:['Analyze patient outcome data','Build clinical dashboards','EHR data quality','Research collaboration','Regulatory data submissions'],
    perks:['₹8–18 LPA','ESOPs','WFH 3 days/week','Health + dental insurance','Learning budget ₹50,000/year'],
    applyUrl:'https://practo.com/careers', contactEmail:'talent@practo.com'),

  JobListing(id:'j14', title:'Clinical Research Associate', hospital:'Sun Pharma R&D',
    city:'Mumbai', state:'Maharashtra', department:'Clinical Research',
    salaryDisplay:'₹6–12 LPA', experience:'2–4 years',
    qualification:'MBBS / M.Pharm / M.Sc Life Sciences', postedAgo:'5 days ago',
    jobType:JobType.fullTime, applicants:112, isVerified:true,
    isUrgent:false, isFeatured:false, isGovt:false, emoji:'🧪',
    skills:['GCP','ICH Guidelines','Site Monitoring','EDC Systems','CDISC'],
    description:'Sun Pharma R&D hiring CRAs to monitor Phase II–III clinical trials across India.',
    responsibilities:['Site initiation, monitoring, close-out visits','Source data verification','Protocol deviation management','SAE/AE reporting'],
    perks:['₹6–12 LPA','Travel reimbursement','ACRP certification support','Global trial experience'],
    applyUrl:'https://sunpharma.com/careers', contactEmail:'cra.hiring@sunpharma.com'),

  JobListing(id:'j15', title:'Dentist – BDS / MDS', hospital:'Clove Dental',
    city:'Multiple Cities', state:'Pan India', department:'Dentistry',
    salaryDisplay:'₹30,000–80,000/month', experience:'0–5 years',
    qualification:'BDS / MDS', postedAgo:'4 days ago',
    jobType:JobType.fullTime, applicants:534, isVerified:true,
    isUrgent:true, isFeatured:true, isGovt:false, emoji:'🦷',
    skills:['Restorations','Root Canal Treatment','Extractions','Orthodontics','Implants'],
    description:'Clove Dental, India\'s largest dental chain with 600+ clinics, hiring dentists across India. Freshers welcome.',
    responsibilities:['General dentistry procedures','RCT and prosthetics','Patient consultation','Treatment planning'],
    perks:['₹30–80K/month + performance bonus','All materials provided','Malpractice insurance','Training on advanced procedures'],
    applyUrl:'https://clovedental.in/careers', contactEmail:'dentist.hiring@clovedental.in'),

  JobListing(id:'j16', title:'MBBS Intern (Rotatory)', hospital:'KIMS Hospitals',
    city:'Hyderabad', state:'Telangana', department:'All Departments',
    salaryDisplay:'₹15,000–20,000/month', experience:'Final Year MBBS',
    qualification:'MBBS Final Year', postedAgo:'1 day ago',
    jobType:JobType.internship, applicants:89, isVerified:true,
    isUrgent:true, isFeatured:false, isGovt:false, emoji:'🩺',
    skills:['Clinical Skills','Patient History','Physical Examination','Ward Management'],
    description:'KIMS Hospitals offers a comprehensive 12-month MCI-compliant rotatory internship for MBBS graduates.',
    responsibilities:['Rotations in all major specialties','OPD and ward duties','Emergency medicine exposure','Case presentations'],
    perks:['₹15–20K/month stipend','MCI-recognized internship','Hostel accommodation','Meals provided'],
    applyUrl:'https://kimshospitals.com/internship', contactEmail:'internship@kimshospitals.com'),
];

// ═══════════════════════════════════════════════════════════
// HOME SCREEN
// ═══════════════════════════════════════════════════════════

class OpportunitiesHomeScreen extends StatefulWidget {
  const OpportunitiesHomeScreen({super.key});
  @override
  State<OpportunitiesHomeScreen> createState() =>
      _OpportunitiesHomeScreenState();
}

class _OpportunitiesHomeScreenState extends State<OpportunitiesHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  final List<JobListing> _jobs = allJobs;
  String _query = '';
  String _dept = 'All';
  String _type = 'All';
  String _city = 'All';
  bool _govtOnly = false;
  bool _fresherOnly = false;
  String _userName = 'Medical Professional';
  String _userRole = 'Doctor';
  String _userEmail = '';

  static const _depts = ['All','Cardiology','Neurology','Surgery','Radiology',
    'Nursing','Pharmacy','Lab','Physiotherapy','Administration','Healthcare IT',
    'Clinical Research','Dentistry'];
  static const _types = ['All','Full Time','Contract','Remote','Internship','Part Time'];
  static const _cities = ['All','Hyderabad','Bengaluru','Mumbai','Delhi',
    'Chennai','Pune','Kochi','Gurugram','Remote / Pan India'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _userName = p.getString('opp_user_name') ?? 'Medical Professional';
      _userRole = p.getString('opp_user_role') ?? 'Doctor';
      _userEmail = p.getString('opp_user_email') ?? '';
    });
  }

  List<JobListing> get _filtered {
    var l = _jobs.toList();
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      l = l.where((j) =>
        j.title.toLowerCase().contains(q) ||
        j.hospital.toLowerCase().contains(q) ||
        j.department.toLowerCase().contains(q) ||
        j.city.toLowerCase().contains(q) ||
        j.skills.any((s) => s.toLowerCase().contains(q))).toList();
    }
    if (_dept != 'All') {
      l = l.where((j) {
        if (_dept == 'Nursing') return j.department.contains('Nurs') || j.department.contains('Critical');
        if (_dept == 'Lab') return j.department.contains('Lab') || j.department.contains('Path');
        return j.department.toLowerCase().contains(_dept.toLowerCase());
      }).toList();
    }
    if (_type != 'All') {
      l = l.where((j) {
        switch (_type) {
          case 'Full Time': return j.jobType == JobType.fullTime;
          case 'Contract': return j.jobType == JobType.contract;
          case 'Remote': return j.jobType == JobType.remote;
          case 'Internship': return j.jobType == JobType.internship;
          default: return true;
        }
      }).toList();
    }
    if (_city != 'All') {
      l = l.where((j) =>
        j.city.toLowerCase().contains(_city.toLowerCase()) ||
        (_city == 'Remote / Pan India' && (j.city == 'Remote' || j.state == 'Pan India'))).toList();
    }
    if (_govtOnly) l = l.where((j) => j.isGovt).toList();
    if (_fresherOnly) l = l.where((j) =>
      j.experience.toLowerCase().contains('fresher') ||
      j.experience.startsWith('0')).toList();
    return l;
  }

  List<JobListing> get _saved => _jobs.where((j) => j.isSaved).toList();
  List<JobListing> get _applied =>
      _jobs.where((j) => j.status != ApplicationStatus.notApplied).toList();

  Future<void> _logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('opp_logged_in', false);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => const OpportunitiesAuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Column(children: [
        _topBar(), _searchRow(), _filterSection(), _tabBar(),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _jobsFeed(), _savedTab(), _profileTab(),
        ])),
      ]),
    );
  }

  Widget _topBar() => Container(
    color: const Color(0xFF0A1628),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16, right: 16, bottom: 12),
    child: Row(children: [
      Container(width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.teal,
            borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.health_and_safety_rounded,
            color: Colors.white, size: 18)),
      const SizedBox(width: 8),
      const Text('AyurVanta', style: TextStyle(color: Colors.white,
          fontSize: 16, fontWeight: FontWeight.w700)),
      Container(
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: AppColors.teal,
            borderRadius: BorderRadius.circular(4)),
        child: const Text('JOBS', style: TextStyle(color: Colors.white,
            fontSize: 9, fontWeight: FontWeight.w800)),
      ),
      const Spacer(),
      Container(width: 34, height: 34,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.notifications_outlined,
            color: Colors.white, size: 18)),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () => _tabController.animateTo(2),
        child: CircleAvatar(radius: 17, backgroundColor: AppColors.teal,
          child: Text(_userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
              style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w800, fontSize: 14))),
      ),
    ]),
  );

  Widget _searchRow() => Container(
    color: const Color(0xFF0A1628),
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
        const SizedBox(width: 10),
        Expanded(child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Job title, hospital, skills…',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13)))),
        if (_query.isNotEmpty) GestureDetector(
          onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
          child: const Icon(Icons.close_rounded, color: AppColors.textHint, size: 18)),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: AppColors.blue,
              borderRadius: BorderRadius.circular(8)),
          child: const Text('Search', style: TextStyle(color: Colors.white,
              fontSize: 12, fontWeight: FontWeight.w700))),
      ]),
    ),
  );

  Widget _filterSection() => Container(
    color: Colors.white,
    child: Column(children: [
      // Department chips
      SizedBox(height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _depts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {
            final d = _depts[i];
            final active = d == _dept;
            return GestureDetector(
              onTap: () => setState(() => _dept = d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: active ? AppColors.blue : const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? AppColors.blue
                      : const Color(0xFFE3EAF2), width: 0.5)),
                child: Text(d, style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.navyLight))));
          })),
      // Quick filter row
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Row(children: [
          _qFilter(_city == 'All' ? '📍 City' : '📍 $_city',
              () => _picker('City', _cities, (v) => setState(() => _city = v))),
          const SizedBox(width: 8),
          _qFilter(_type == 'All' ? '💼 Type' : '💼 $_type',
              () => _picker('Type', _types, (v) => setState(() => _type = v))),
          const SizedBox(width: 8),
          _toggleChip('🏛️ Govt', _govtOnly,
              () => setState(() => _govtOnly = !_govtOnly), const Color(0xFF0F6E56)),
          const SizedBox(width: 8),
          _toggleChip('🌱 Fresher', _fresherOnly,
              () => setState(() => _fresherOnly = !_fresherOnly), AppColors.teal),
        ])),
      // Count bar
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(children: [
          Text('${_filtered.length} jobs found',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          if (_filtered.any((j) => j.isUrgent))
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFCEBEB),
                  borderRadius: BorderRadius.circular(6)),
              child: Text('${_filtered.where((j) => j.isUrgent).length} urgent',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: Color(0xFFE24B4A)))),
        ])),
      const Divider(height: 1, color: Color(0xFFE3EAF2)),
    ]),
  );

  Widget _qFilter(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE3EAF2))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: const TextStyle(fontSize: 11,
            fontWeight: FontWeight.w600, color: AppColors.navyLight)),
        const SizedBox(width: 3),
        const Icon(Icons.keyboard_arrow_down_rounded,
            size: 14, color: AppColors.textHint),
      ]),
    ),
  );

  Widget _toggleChip(String label, bool active, VoidCallback onTap, Color color) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active ? color : const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: active ? color : const Color(0xFFE3EAF2))),
          child: Text(label, style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.navyLight))),
      );

  void _picker(String title, List<String> opts, Function(String) sel) {
    showModalBottomSheet(context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(color: const Color(0xFFE3EAF2),
                  borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(16),
              child: Text(title, style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w700))),
          Flexible(child: ListView.builder(shrinkWrap: true,
              itemCount: opts.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(opts[i]),
                onTap: () { sel(opts[i]); Navigator.pop(context); }))),
          const SizedBox(height: 16),
        ]));
  }

  Widget _tabBar() => Container(
    color: Colors.white,
    child: TabBar(
      controller: _tabController,
      indicator: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.blue, width: 2.5))),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: const Color(0xFFE3EAF2),
      labelColor: AppColors.blue,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: [
        const Tab(text: 'Jobs'),
        Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Saved'),
          if (_saved.isNotEmpty) Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: AppColors.blue,
                borderRadius: BorderRadius.circular(10)),
            child: Text('${_saved.length}', style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
        ])),
        const Tab(text: 'Profile'),
      ],
    ),
  );

  Widget _jobsFeed() {
    final j = _filtered;
    if (j.isEmpty) return const Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('🔍', style: TextStyle(fontSize: 48)),
        SizedBox(height: 16),
        Text('No jobs found', style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text('Try different filters', style: TextStyle(
            color: AppColors.textSecondary, fontSize: 13)),
      ]));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: j.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: (i % 8) * 50),
        child: _JobCard(job: j[i],
          onSave: () => setState(() => j[i].isSaved = !j[i].isSaved),
          onApply: () => _applySheet(j[i]))));
  }

  Widget _savedTab() {
    if (_saved.isEmpty) return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🔖', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('No saved jobs yet', style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text('Tap the bookmark icon to save jobs',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => _tabController.animateTo(0),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue,
                foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Browse Jobs')),
      ]));
    return ListView.builder(padding: const EdgeInsets.all(16),
        itemCount: _saved.length,
        itemBuilder: (_, i) => _JobCard(job: _saved[i],
          onSave: () => setState(() => _saved[i].isSaved = false),
          onApply: () => _applySheet(_saved[i])));
  }

  Widget _profileTab() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      // Profile card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
        child: Column(children: [
          CircleAvatar(radius: 36, backgroundColor: AppColors.blue,
            child: Text(_userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w800, fontSize: 28))),
          const SizedBox(height: 12),
          Text(_userName, style: const TextStyle(fontSize: 18,
              fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(_userRole, style: const TextStyle(fontSize: 13,
              color: AppColors.blue, fontWeight: FontWeight.w600)),
          Text(_userEmail, style: const TextStyle(fontSize: 12,
              color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(children: [
            _pStat('${_applied.length}', 'Applied'),
            _pStat('${_saved.length}', 'Saved'),
            _pStat('0', 'Interviews'),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      if (_applied.isNotEmpty) ...[
        const Align(alignment: Alignment.centerLeft,
            child: Text('Applied Jobs', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
        const SizedBox(height: 10),
        ..._applied.map((j) => _appliedRow(j)),
        const SizedBox(height: 16),
      ],
      Container(
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
        child: Column(children: [
          _pOpt(Icons.person_outline_rounded, 'Edit Profile', () {}),
          _pOpt(Icons.upload_file_rounded, 'Upload Resume', () {}),
          _pOpt(Icons.notifications_outlined, 'Job Alerts', () {}),
          _pOpt(Icons.privacy_tip_outlined, 'Privacy Settings', () {}),
          _pOpt(Icons.help_outline_rounded, 'Help & Support', () {}),
          _pOpt(Icons.logout_rounded, 'Logout',
              () => _confirmLogout(), color: const Color(0xFFE24B4A), isLast: true),
        ]),
      ),
    ]),
  );

  Widget _pStat(String v, String l) => Expanded(child: Column(children: [
    Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
        color: AppColors.textPrimary)),
    Text(l, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
  ]));

  Widget _pOpt(IconData icon, String label, VoidCallback onTap,
      {Color? color, bool isLast = false}) =>
      GestureDetector(onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(border: isLast ? null : const Border(
              bottom: BorderSide(color: Color(0xFFF0F4F8), width: 0.5))),
          child: Row(children: [
            Icon(icon, color: color ?? AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.textPrimary))),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: AppColors.textHint),
          ]),
        ));

  Widget _appliedRow(JobListing j) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
    child: Row(children: [
      Text(j.emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(j.title, style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(j.hospital, style: const TextStyle(fontSize: 11,
                color: AppColors.textSecondary)),
          ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: const Color(0xFFEAF3DE),
              borderRadius: BorderRadius.circular(6)),
          child: const Text('Applied', style: TextStyle(fontSize: 10,
              fontWeight: FontWeight.w700, color: Color(0xFF3B6D11)))),
    ]),
  );

  void _confirmLogout() => showDialog(context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Logout from AyurVanta Jobs?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(onPressed: () { Navigator.pop(context); _logout(); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE24B4A),
                  foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Logout')),
        ]));

  void _applySheet(JobListing job) {
    final coverCtrl = TextEditingController();
    bool submitting = false;
    showModalBottomSheet(context: context, isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StatefulBuilder(builder: (ctx, setS) =>
          DraggableScrollableSheet(initialChildSize: 0.85,
            maxChildSize: 0.95, minChildSize: 0.5,
            builder: (_, scroll) => Container(
              decoration: const BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(children: [
                Container(width: 40, height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(color: const Color(0xFFE3EAF2),
                        borderRadius: BorderRadius.circular(2))),
                Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Row(children: [
                      Text(job.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(job.title, style: const TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        Text(job.hospital, style: const TextStyle(fontSize: 12,
                            color: AppColors.textSecondary)),
                      ])),
                      GestureDetector(onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded,
                              color: AppColors.textHint)),
                    ])),
                Expanded(child: ListView(controller: scroll,
                    padding: const EdgeInsets.all(20), children: [
                  const Text('Apply for this Position', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  Container(padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      CircleAvatar(radius: 20, backgroundColor: AppColors.blue,
                        child: Text(_userName.isNotEmpty
                            ? _userName[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800))),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_userName, style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700)),
                        Text(_userRole, style: const TextStyle(fontSize: 11,
                            color: AppColors.textSecondary)),
                      ])),
                      Container(padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFEAF3DE),
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text('Auto-fill', style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: Color(0xFF3B6D11)))),
                    ])),
                  const SizedBox(height: 16),
                  GestureDetector(onTap: () {},
                    child: Container(padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(border: Border.all(
                          color: AppColors.blue, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(children: [
                        Icon(Icons.upload_file_rounded,
                            color: AppColors.blue, size: 22),
                        SizedBox(width: 10),
                        Text('Upload Resume (PDF/DOC)', style: TextStyle(
                            fontSize: 13, color: AppColors.blue,
                            fontWeight: FontWeight.w600)),
                      ]))),
                  const SizedBox(height: 16),
                  const Text('Cover Letter (optional)', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextField(controller: coverCtrl, maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tell the employer why you\'re a good fit…',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 12),
                      filled: true, fillColor: const Color(0xFFF4F7FB),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE3EAF2), width: 0.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE3EAF2), width: 0.5)),
                      contentPadding: const EdgeInsets.all(14))),
                  const SizedBox(height: 30),
                ])),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20,
                    MediaQuery.of(ctx).padding.bottom + 16),
                  child: SizedBox(width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: submitting ? null : () async {
                        setS(() => submitting = true);
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() => job.status = ApplicationStatus.applied);
                        if (!mounted) return;
                        Navigator.pop(ctx);
                        HapticFeedback.heavyImpact();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                                'Applied to ${job.title} at ${job.hospital}! 🎉')),
                          ]),
                          backgroundColor: AppColors.teal,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white, elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: submitting
                          ? const SizedBox(width: 22, height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Text('Submit Application', style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700))))),
              ])))));
  }
}

// ═══════════════════════════════════════════════════════════
// JOB CARD
// ═══════════════════════════════════════════════════════════

class _JobCard extends StatelessWidget {
  final JobListing job;
  final VoidCallback onSave, onApply;
  const _JobCard({required this.job, required this.onSave, required this.onApply});

  String get _typeLabel {
    switch (job.jobType) {
      case JobType.fullTime: return 'Full Time';
      case JobType.contract: return 'Contract';
      case JobType.remote: return 'Remote';
      case JobType.internship: return 'Internship';
      case JobType.partTime: return 'Part Time';
      default: return 'Locum';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _detail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: job.isFeatured
                ? AppColors.blue.withOpacity(0.3) : const Color(0xFFE3EAF2),
            width: job.isFeatured ? 1.5 : 0.5)),
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(14), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 48, height: 48,
                decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
                child: Center(child: Text(job.emoji,
                    style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(job.title, style: const TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Row(children: [
                  Text(job.hospital, style: const TextStyle(fontSize: 12,
                      color: AppColors.blue, fontWeight: FontWeight.w600)),
                  if (job.isVerified) const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.verified_rounded,
                          color: AppColors.blue, size: 13)),
                ]),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 12,
                      color: AppColors.textHint),
                  Text('${job.city}, ${job.state}',
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                ]),
              ])),
              GestureDetector(onTap: onSave,
                child: Padding(padding: const EdgeInsets.all(4),
                  child: Icon(job.isSaved ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                      color: job.isSaved ? AppColors.blue : AppColors.textHint,
                      size: 22))),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              _tag(job.salaryDisplay, AppColors.teal, const Color(0xFFEAF3DE)),
              _tag(_typeLabel, AppColors.blue, AppColors.blueLight),
              _tag(job.experience, AppColors.navyLight, const Color(0xFFF4F7FB)),
              if (job.isGovt) _tag('🏛️ Govt', const Color(0xFF0F6E56), const Color(0xFFE1F5EE)),
              if (job.isUrgent) _tag('🔴 Urgent', const Color(0xFFE24B4A), const Color(0xFFFCEBEB)),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 5, runSpacing: 5,
              children: job.skills.take(3).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE3EAF2), width: 0.5)),
                child: Text(s, style: const TextStyle(fontSize: 10,
                    color: AppColors.textSecondary)))).toList()),
          ])),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            decoration: const BoxDecoration(border: Border(top: BorderSide(
                color: Color(0xFFF0F4F8), width: 0.5))),
            child: Row(children: [
              Text('${job.applicants} applicants · ${job.postedAgo}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              const Spacer(),
              if (job.status == ApplicationStatus.applied)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('✓ Applied', style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700, color: Color(0xFF3B6D11))))
              else GestureDetector(onTap: onApply,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(color: AppColors.blue,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Apply Now', style: TextStyle(color: Colors.white,
                      fontSize: 12, fontWeight: FontWeight.w700)))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _tag(String t, Color tc, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
    child: Text(t, style: TextStyle(fontSize: 10,
        fontWeight: FontWeight.w700, color: tc)));

  void _detail(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.9, maxChildSize: 0.97, minChildSize: 0.5,
          builder: (_, scroll) => Container(
            decoration: const BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(color: const Color(0xFFE3EAF2),
                      borderRadius: BorderRadius.circular(2))),
              Expanded(child: ListView(controller: scroll,
                  padding: const EdgeInsets.all(20), children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 56, height: 56,
                    decoration: BoxDecoration(color: const Color(0xFFF4F7FB),
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text(job.emoji,
                        style: const TextStyle(fontSize: 28)))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(job.title, style: const TextStyle(fontSize: 18,
                        fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Row(children: [
                      Text(job.hospital, style: const TextStyle(fontSize: 13,
                          color: AppColors.blue, fontWeight: FontWeight.w600)),
                      if (job.isVerified) const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Icon(Icons.verified_rounded,
                              color: AppColors.blue, size: 14)),
                    ]),
                    Text('${job.city}, ${job.state} · ${job.department}',
                        style: const TextStyle(fontSize: 11,
                            color: AppColors.textSecondary)),
                  ])),
                ]),
                const SizedBox(height: 16),
                GridView.count(shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
                    childAspectRatio: 2.5,
                    children: [
                      _infoBox('💰 Salary', job.salaryDisplay, AppColors.teal),
                      _infoBox('⏱️ Experience', job.experience, AppColors.blue),
                      _infoBox('🎓 Qualification', job.qualification, AppColors.navyLight),
                      _infoBox('👥 Applicants', '${job.applicants}', const Color(0xFF854F0B)),
                    ]),
                const SizedBox(height: 16),
                const Text('About this Role', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text(job.description, style: const TextStyle(fontSize: 13,
                    color: AppColors.textSecondary, height: 1.6)),
                const SizedBox(height: 16),
                const Text('Key Responsibilities', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                ...job.responsibilities.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.arrow_right_rounded,
                        color: AppColors.blue, size: 18),
                    const SizedBox(width: 4),
                    Expanded(child: Text(r, style: const TextStyle(fontSize: 12,
                        color: AppColors.textSecondary, height: 1.5))),
                  ]))),
                const SizedBox(height: 16),
                const Text('Required Skills', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8,
                    children: job.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(s, style: const TextStyle(fontSize: 12,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600)))).toList()),
                const SizedBox(height: 16),
                const Text('Perks & Benefits', style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                ...job.perks.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.teal, size: 16),
                    const SizedBox(width: 8),
                    Text(p, style: const TextStyle(fontSize: 12,
                        color: AppColors.textSecondary)),
                  ]))),
                const SizedBox(height: 30),
              ])),
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20,
                  MediaQuery.of(context).padding.bottom + 16),
                child: Row(children: [
                  GestureDetector(onSave,
                    child: Container(width: 50, height: 50,
                      decoration: BoxDecoration(border: Border.all(
                          color: const Color(0xFFE3EAF2)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(job.isSaved ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                          color: job.isSaved ? AppColors.blue : AppColors.textHint))),
                  const SizedBox(width: 12),
                  Expanded(child: SizedBox(height: 50,
                    child: ElevatedButton(
                      onPressed: job.status == ApplicationStatus.applied
                          ? null : () { Navigator.pop(context); onApply(); },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFEAF3DE),
                          disabledForegroundColor: const Color(0xFF3B6D11),
                          elevation: 0, shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: Text(job.status == ApplicationStatus.applied
                          ? '✓ Applied' : 'Apply Now',
                          style: const TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700))))),
                ])),
            ]),
          )));
  }

  Widget _infoBox(String label, String value, Color color) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(label, style: const TextStyle(fontSize: 9,
          color: AppColors.textSecondary)),
      Text(value, style: TextStyle(fontSize: 12,
          fontWeight: FontWeight.w700, color: color),
          maxLines: 1, overflow: TextOverflow.ellipsis),
    ]));
}