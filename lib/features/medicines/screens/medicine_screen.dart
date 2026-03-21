import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════

class Medicine {
  final String id;
  final String name;
  final String genericName;
  final String brand;
  final String specialization;
  final String category;
  final String dosageForm;
  final String strength;
  final String pack;
  final int price;
  final int mrp;
  final bool requiresRx;
  final String emoji;
  final String description;
  final String sideEffects;

  const Medicine({
    required this.id,
    required this.name,
    required this.genericName,
    required this.brand,
    required this.specialization,
    required this.category,
    required this.dosageForm,
    required this.strength,
    required this.pack,
    required this.price,
    required this.mrp,
    required this.requiresRx,
    required this.emoji,
    required this.description,
    required this.sideEffects,
  });

  int get discount => (((mrp - price) / mrp) * 100).round();
}

class CartItem {
  final Medicine medicine;
  int quantity;
  CartItem({required this.medicine, this.quantity = 1});
}

// ═══════════════════════════════════════════════════════════
// MEDICINE DATABASE — All major specializations
// ═══════════════════════════════════════════════════════════

const List<Medicine> allMedicines = [
  // ── CARDIOLOGY ────────────────────────────────────────
  Medicine(
    id: 'c001', name: 'Amlodipine 5mg', genericName: 'Amlodipine Besylate',
    brand: 'Amlip', specialization: 'Cardiology', category: 'Calcium Channel Blocker',
    dosageForm: 'Tablet', strength: '5mg', pack: 'Strip of 10',
    price: 48, mrp: 62, requiresRx: true, emoji: '💊',
    description: 'Used to treat high blood pressure and chest pain (angina). Relaxes blood vessels.',
    sideEffects: 'Swelling, flushing, dizziness, headache',
  ),
  Medicine(
    id: 'c002', name: 'Atorvastatin 10mg', genericName: 'Atorvastatin Calcium',
    brand: 'Lipitor', specialization: 'Cardiology', category: 'Statin',
    dosageForm: 'Tablet', strength: '10mg', pack: 'Strip of 10',
    price: 85, mrp: 110, requiresRx: true, emoji: '💊',
    description: 'Lowers bad cholesterol (LDL) and triglycerides. Reduces heart attack risk.',
    sideEffects: 'Muscle pain, liver enzyme changes, nausea',
  ),
  Medicine(
    id: 'c003', name: 'Aspirin 75mg', genericName: 'Acetylsalicylic Acid',
    brand: 'Ecosprin', specialization: 'Cardiology', category: 'Antiplatelet',
    dosageForm: 'Tablet', strength: '75mg', pack: 'Strip of 14',
    price: 22, mrp: 30, requiresRx: false, emoji: '💊',
    description: 'Prevents blood clots. Used in heart attack and stroke prevention.',
    sideEffects: 'Stomach irritation, bleeding risk, tinnitus',
  ),
  Medicine(
    id: 'c004', name: 'Metoprolol 25mg', genericName: 'Metoprolol Succinate',
    brand: 'Metolar', specialization: 'Cardiology', category: 'Beta Blocker',
    dosageForm: 'Tablet', strength: '25mg', pack: 'Strip of 10',
    price: 55, mrp: 72, requiresRx: true, emoji: '💊',
    description: 'Reduces heart rate and blood pressure. Used for hypertension, angina, heart failure.',
    sideEffects: 'Fatigue, dizziness, cold hands/feet, slow heartbeat',
  ),
  Medicine(
    id: 'c005', name: 'Telmisartan 40mg', genericName: 'Telmisartan',
    brand: 'Telma', specialization: 'Cardiology', category: 'ARB',
    dosageForm: 'Tablet', strength: '40mg', pack: 'Strip of 10',
    price: 95, mrp: 125, requiresRx: true, emoji: '💊',
    description: 'Angiotensin receptor blocker for high blood pressure. Protects kidneys in diabetics.',
    sideEffects: 'Dizziness, diarrhea, upper respiratory infections',
  ),
  Medicine(
    id: 'c006', name: 'Furosemide 40mg', genericName: 'Furosemide',
    brand: 'Lasix', specialization: 'Cardiology', category: 'Diuretic',
    dosageForm: 'Tablet', strength: '40mg', pack: 'Strip of 10',
    price: 18, mrp: 25, requiresRx: true, emoji: '💊',
    description: 'Loop diuretic used for fluid retention in heart failure, kidney disease, and hypertension.',
    sideEffects: 'Frequent urination, low potassium, dehydration',
  ),

  // ── DIABETES / ENDOCRINOLOGY ──────────────────────────
  Medicine(
    id: 'd001', name: 'Metformin 500mg', genericName: 'Metformin HCl',
    brand: 'Glycomet', specialization: 'Diabetes', category: 'Biguanide',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 10',
    price: 35, mrp: 45, requiresRx: true, emoji: '🩸',
    description: 'First-line diabetes medication. Reduces glucose production in liver.',
    sideEffects: 'Nausea, stomach upset, diarrhea, vitamin B12 deficiency',
  ),
  Medicine(
    id: 'd002', name: 'Glimepiride 1mg', genericName: 'Glimepiride',
    brand: 'Amaryl', specialization: 'Diabetes', category: 'Sulfonylurea',
    dosageForm: 'Tablet', strength: '1mg', pack: 'Strip of 10',
    price: 42, mrp: 55, requiresRx: true, emoji: '🩸',
    description: 'Stimulates insulin release from pancreas. Lowers blood sugar in type 2 diabetes.',
    sideEffects: 'Low blood sugar, weight gain, nausea',
  ),
  Medicine(
    id: 'd003', name: 'Sitagliptin 50mg', genericName: 'Sitagliptin Phosphate',
    brand: 'Januvia', specialization: 'Diabetes', category: 'DPP-4 Inhibitor',
    dosageForm: 'Tablet', strength: '50mg', pack: 'Strip of 7',
    price: 285, mrp: 350, requiresRx: true, emoji: '🩸',
    description: 'DPP-4 inhibitor that helps control blood sugar. Works with other diabetes medications.',
    sideEffects: 'Upper respiratory infection, headache, joint pain',
  ),
  Medicine(
    id: 'd004', name: 'Insulin Glargine 100IU', genericName: 'Insulin Glargine',
    brand: 'Lantus', specialization: 'Diabetes', category: 'Insulin (Long-Acting)',
    dosageForm: 'Injection', strength: '100 IU/mL', pack: '3mL Cartridge',
    price: 850, mrp: 980, requiresRx: true, emoji: '💉',
    description: 'Long-acting insulin analog for type 1 and type 2 diabetes. Once-daily injection.',
    sideEffects: 'Low blood sugar, injection site reactions, weight gain',
  ),
  Medicine(
    id: 'd005', name: 'Empagliflozin 10mg', genericName: 'Empagliflozin',
    brand: 'Jardiance', specialization: 'Diabetes', category: 'SGLT2 Inhibitor',
    dosageForm: 'Tablet', strength: '10mg', pack: 'Strip of 10',
    price: 420, mrp: 520, requiresRx: true, emoji: '🩸',
    description: 'Removes excess glucose through urine. Also protects heart and kidneys in diabetics.',
    sideEffects: 'Urinary tract infections, genital infections, frequent urination',
  ),
  Medicine(
    id: 'd006', name: 'Thyroxine 50mcg', genericName: 'Levothyroxine Sodium',
    brand: 'Eltroxin', specialization: 'Diabetes', category: 'Thyroid Hormone',
    dosageForm: 'Tablet', strength: '50mcg', pack: 'Strip of 30',
    price: 52, mrp: 68, requiresRx: true, emoji: '🦋',
    description: 'Synthetic thyroid hormone for hypothyroidism. Taken on empty stomach daily.',
    sideEffects: 'Palpitations if overdosed, weight changes, insomnia',
  ),

  // ── GASTROENTEROLOGY ──────────────────────────────────
  Medicine(
    id: 'g001', name: 'Omeprazole 20mg', genericName: 'Omeprazole',
    brand: 'Omez', specialization: 'Gastroenterology', category: 'PPI',
    dosageForm: 'Capsule', strength: '20mg', pack: 'Strip of 10',
    price: 38, mrp: 52, requiresRx: false, emoji: '🫃',
    description: 'Proton pump inhibitor. Reduces stomach acid for GERD, ulcers, and gastritis.',
    sideEffects: 'Headache, nausea, diarrhea, vitamin B12 deficiency long-term',
  ),
  Medicine(
    id: 'g002', name: 'Pantoprazole 40mg', genericName: 'Pantoprazole Sodium',
    brand: 'Pan', specialization: 'Gastroenterology', category: 'PPI',
    dosageForm: 'Tablet', strength: '40mg', pack: 'Strip of 10',
    price: 45, mrp: 60, requiresRx: false, emoji: '🫃',
    description: 'Reduces stomach acid production. Used for peptic ulcers and acid reflux.',
    sideEffects: 'Headache, diarrhea, flatulence, abdominal pain',
  ),
  Medicine(
    id: 'g003', name: 'Domperidone 10mg', genericName: 'Domperidone',
    brand: 'Domstal', specialization: 'Gastroenterology', category: 'Prokinetic',
    dosageForm: 'Tablet', strength: '10mg', pack: 'Strip of 10',
    price: 28, mrp: 38, requiresRx: false, emoji: '🫃',
    description: 'Anti-nausea medication. Speeds up stomach emptying and reduces reflux.',
    sideEffects: 'Dry mouth, headache, diarrhea, galactorrhea rarely',
  ),
  Medicine(
    id: 'g004', name: 'Ondansetron 4mg', genericName: 'Ondansetron HCl',
    brand: 'Emeset', specialization: 'Gastroenterology', category: 'Antiemetic',
    dosageForm: 'Tablet', strength: '4mg', pack: 'Strip of 10',
    price: 55, mrp: 72, requiresRx: true, emoji: '🤢',
    description: 'Prevents and treats nausea and vomiting from chemotherapy or surgery.',
    sideEffects: 'Constipation, headache, dizziness, fatigue',
  ),
  Medicine(
    id: 'g005', name: 'Mesalamine 400mg', genericName: 'Mesalazine',
    brand: 'Asacol', specialization: 'Gastroenterology', category: 'Aminosalicylate',
    dosageForm: 'Tablet', strength: '400mg', pack: 'Strip of 10',
    price: 185, mrp: 240, requiresRx: true, emoji: '🫃',
    description: 'Anti-inflammatory for ulcerative colitis and Crohn\'s disease.',
    sideEffects: 'Abdominal pain, nausea, headache, diarrhea',
  ),

  // ── NEUROLOGY ─────────────────────────────────────────
  Medicine(
    id: 'n001', name: 'Levetiracetam 500mg', genericName: 'Levetiracetam',
    brand: 'Keppra', specialization: 'Neurology', category: 'Antiepileptic',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 10',
    price: 185, mrp: 240, requiresRx: true, emoji: '🧠',
    description: 'Controls various types of seizures in epilepsy. Broad-spectrum antiepileptic.',
    sideEffects: 'Drowsiness, dizziness, irritability, weakness',
  ),
  Medicine(
    id: 'n002', name: 'Carbamazepine 200mg', genericName: 'Carbamazepine',
    brand: 'Tegretol', specialization: 'Neurology', category: 'Antiepileptic',
    dosageForm: 'Tablet', strength: '200mg', pack: 'Strip of 10',
    price: 42, mrp: 58, requiresRx: true, emoji: '🧠',
    description: 'Treats epilepsy, trigeminal neuralgia, and bipolar disorder.',
    sideEffects: 'Drowsiness, nausea, vision problems, low sodium',
  ),
  Medicine(
    id: 'n003', name: 'Sumatriptan 50mg', genericName: 'Sumatriptan Succinate',
    brand: 'Suminat', specialization: 'Neurology', category: 'Triptan',
    dosageForm: 'Tablet', strength: '50mg', pack: 'Strip of 2',
    price: 145, mrp: 185, requiresRx: true, emoji: '🤕',
    description: 'Relieves migraine headaches with or without aura. Constricts blood vessels.',
    sideEffects: 'Tingling, warm sensation, chest tightness, dizziness',
  ),
  Medicine(
    id: 'n004', name: 'Donepezil 5mg', genericName: 'Donepezil HCl',
    brand: 'Aricept', specialization: 'Neurology', category: 'Cholinesterase Inhibitor',
    dosageForm: 'Tablet', strength: '5mg', pack: 'Strip of 10',
    price: 320, mrp: 420, requiresRx: true, emoji: '🧠',
    description: 'Improves memory and cognitive function in Alzheimer\'s disease.',
    sideEffects: 'Nausea, diarrhea, insomnia, muscle cramps',
  ),
  Medicine(
    id: 'n005', name: 'Pregabalin 75mg', genericName: 'Pregabalin',
    brand: 'Lyrica', specialization: 'Neurology', category: 'Anticonvulsant',
    dosageForm: 'Capsule', strength: '75mg', pack: 'Strip of 10',
    price: 168, mrp: 215, requiresRx: true, emoji: '🧠',
    description: 'Treats neuropathic pain, fibromyalgia, and certain types of seizures.',
    sideEffects: 'Dizziness, sleepiness, weight gain, blurred vision',
  ),

  // ── PULMONOLOGY / RESPIRATORY ─────────────────────────
  Medicine(
    id: 'r001', name: 'Salbutamol 100mcg', genericName: 'Salbutamol Sulphate',
    brand: 'Asthalin', specialization: 'Respiratory', category: 'Bronchodilator',
    dosageForm: 'Inhaler', strength: '100mcg/dose', pack: '200 doses',
    price: 145, mrp: 185, requiresRx: false, emoji: '🫁',
    description: 'Relieves bronchospasm in asthma and COPD. Quick-relief rescue inhaler.',
    sideEffects: 'Tremor, rapid heart rate, headache, low potassium',
  ),
  Medicine(
    id: 'r002', name: 'Budesonide 200mcg', genericName: 'Budesonide',
    brand: 'Budecort', specialization: 'Respiratory', category: 'Corticosteroid Inhaler',
    dosageForm: 'Inhaler', strength: '200mcg/dose', pack: '200 doses',
    price: 285, mrp: 365, requiresRx: true, emoji: '🫁',
    description: 'Prevents asthma attacks. Reduces inflammation in airways for long-term control.',
    sideEffects: 'Oral thrush, hoarseness, cough — rinse mouth after use',
  ),
  Medicine(
    id: 'r003', name: 'Montelukast 10mg', genericName: 'Montelukast Sodium',
    brand: 'Montair', specialization: 'Respiratory', category: 'Leukotriene Antagonist',
    dosageForm: 'Tablet', strength: '10mg', pack: 'Strip of 10',
    price: 95, mrp: 125, requiresRx: true, emoji: '🫁',
    description: 'Prevents asthma symptoms and treats seasonal allergies.',
    sideEffects: 'Headache, stomach pain, mood changes, increased bleeding',
  ),
  Medicine(
    id: 'r004', name: 'N-Acetylcysteine 600mg', genericName: 'N-Acetylcysteine',
    brand: 'Mucomelt', specialization: 'Respiratory', category: 'Mucolytic',
    dosageForm: 'Tablet', strength: '600mg', pack: 'Strip of 10',
    price: 68, mrp: 88, requiresRx: false, emoji: '🫁',
    description: 'Thins and loosens mucus in airways. Also used as antidote for paracetamol overdose.',
    sideEffects: 'Nausea, vomiting, skin rash, unusual smell',
  ),

  // ── DERMATOLOGY ───────────────────────────────────────
  Medicine(
    id: 'sk001', name: 'Betamethasone 0.1% Cream', genericName: 'Betamethasone Valerate',
    brand: 'Betnovate', specialization: 'Dermatology', category: 'Topical Corticosteroid',
    dosageForm: 'Cream', strength: '0.1%', pack: '20g tube',
    price: 85, mrp: 110, requiresRx: true, emoji: '🧴',
    description: 'Treats skin inflammation, eczema, psoriasis, and allergic reactions.',
    sideEffects: 'Skin thinning with long-term use, stretch marks, acne',
  ),
  Medicine(
    id: 'sk002', name: 'Clotrimazole 1% Cream', genericName: 'Clotrimazole',
    brand: 'Candid', specialization: 'Dermatology', category: 'Antifungal',
    dosageForm: 'Cream', strength: '1%', pack: '15g tube',
    price: 55, mrp: 72, requiresRx: false, emoji: '🧴',
    description: 'Treats fungal skin infections including ringworm, athlete\'s foot, and candidiasis.',
    sideEffects: 'Local irritation, burning sensation, skin redness',
  ),
  Medicine(
    id: 'sk003', name: 'Tretinoin 0.025% Cream', genericName: 'Tretinoin',
    brand: 'Retino-A', specialization: 'Dermatology', category: 'Retinoid',
    dosageForm: 'Cream', strength: '0.025%', pack: '20g tube',
    price: 125, mrp: 160, requiresRx: true, emoji: '🧴',
    description: 'Treats acne vulgaris and reduces fine wrinkles. Increases skin cell turnover.',
    sideEffects: 'Skin peeling, redness, increased sun sensitivity',
  ),
  Medicine(
    id: 'sk004', name: 'Mupirocin 2% Ointment', genericName: 'Mupirocin',
    brand: 'Bactroban', specialization: 'Dermatology', category: 'Topical Antibiotic',
    dosageForm: 'Ointment', strength: '2%', pack: '5g tube',
    price: 95, mrp: 125, requiresRx: true, emoji: '🩹',
    description: 'Antibiotic ointment for bacterial skin infections like impetigo and infected wounds.',
    sideEffects: 'Local burning, stinging, itching at application site',
  ),

  // ── PSYCHIATRY ────────────────────────────────────────
  Medicine(
    id: 'p001', name: 'Sertraline 50mg', genericName: 'Sertraline HCl',
    brand: 'Zoloft', specialization: 'Psychiatry', category: 'SSRI Antidepressant',
    dosageForm: 'Tablet', strength: '50mg', pack: 'Strip of 10',
    price: 145, mrp: 185, requiresRx: true, emoji: '🧘',
    description: 'Treats depression, anxiety disorders, OCD, PTSD. Takes 4-6 weeks for full effect.',
    sideEffects: 'Nausea, insomnia, sexual dysfunction, dry mouth',
  ),
  Medicine(
    id: 'p002', name: 'Clonazepam 0.5mg', genericName: 'Clonazepam',
    brand: 'Rivotril', specialization: 'Psychiatry', category: 'Benzodiazepine',
    dosageForm: 'Tablet', strength: '0.5mg', pack: 'Strip of 10',
    price: 42, mrp: 55, requiresRx: true, emoji: '🧘',
    description: 'Treats panic disorder, certain types of seizures, and anxiety.',
    sideEffects: 'Drowsiness, coordination problems, dependence risk',
  ),
  Medicine(
    id: 'p003', name: 'Olanzapine 5mg', genericName: 'Olanzapine',
    brand: 'Oleanz', specialization: 'Psychiatry', category: 'Antipsychotic',
    dosageForm: 'Tablet', strength: '5mg', pack: 'Strip of 10',
    price: 95, mrp: 125, requiresRx: true, emoji: '🧘',
    description: 'Treats schizophrenia and bipolar disorder. Also used for agitation.',
    sideEffects: 'Weight gain, sedation, metabolic changes, tardive dyskinesia',
  ),
  Medicine(
    id: 'p004', name: 'Alprazolam 0.25mg', genericName: 'Alprazolam',
    brand: 'Alprax', specialization: 'Psychiatry', category: 'Benzodiazepine',
    dosageForm: 'Tablet', strength: '0.25mg', pack: 'Strip of 10',
    price: 28, mrp: 38, requiresRx: true, emoji: '🧘',
    description: 'Short-term treatment of anxiety disorders and panic attacks.',
    sideEffects: 'Dependence, sedation, cognitive impairment, withdrawal',
  ),

  // ── ORTHOPEDICS / PAIN ────────────────────────────────
  Medicine(
    id: 'o001', name: 'Diclofenac 50mg', genericName: 'Diclofenac Sodium',
    brand: 'Voveran', specialization: 'Orthopedics', category: 'NSAID',
    dosageForm: 'Tablet', strength: '50mg', pack: 'Strip of 10',
    price: 32, mrp: 42, requiresRx: false, emoji: '🦴',
    description: 'Anti-inflammatory and pain reliever for arthritis, muscle pain, and injuries.',
    sideEffects: 'Stomach upset, ulcer risk, kidney effects, cardiovascular risk',
  ),
  Medicine(
    id: 'o002', name: 'Paracetamol 500mg', genericName: 'Paracetamol (Acetaminophen)',
    brand: 'Crocin', specialization: 'Orthopedics', category: 'Analgesic/Antipyretic',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 15',
    price: 18, mrp: 24, requiresRx: false, emoji: '🌡️',
    description: 'Fever reducer and mild pain reliever. Safe for most people in recommended doses.',
    sideEffects: 'Liver damage if overdosed, allergic reactions rarely',
  ),
  Medicine(
    id: 'o003', name: 'Calcium + Vit D3', genericName: 'Calcium Carbonate + Cholecalciferol',
    brand: 'Shelcal', specialization: 'Orthopedics', category: 'Bone Supplement',
    dosageForm: 'Tablet', strength: '500mg + 250IU', pack: 'Strip of 15',
    price: 95, mrp: 125, requiresRx: false, emoji: '🦴',
    description: 'Treats calcium and vitamin D deficiency. Essential for bone health and osteoporosis.',
    sideEffects: 'Constipation, bloating, kidney stones if overused',
  ),
  Medicine(
    id: 'o004', name: 'Tramadol 50mg', genericName: 'Tramadol HCl',
    brand: 'Ultracet', specialization: 'Orthopedics', category: 'Opioid Analgesic',
    dosageForm: 'Capsule', strength: '50mg', pack: 'Strip of 10',
    price: 65, mrp: 85, requiresRx: true, emoji: '💊',
    description: 'Moderate to severe pain relief. Central-acting analgesic for post-surgical pain.',
    sideEffects: 'Nausea, dizziness, constipation, dependence risk',
  ),
  Medicine(
    id: 'o005', name: 'Glucosamine 500mg', genericName: 'Glucosamine Sulphate',
    brand: 'Osteocare', specialization: 'Orthopedics', category: 'Joint Supplement',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 10',
    price: 185, mrp: 240, requiresRx: false, emoji: '🦴',
    description: 'Supports cartilage health and reduces joint pain in osteoarthritis.',
    sideEffects: 'Mild stomach upset, shellfish allergy risk',
  ),

  // ── OPHTHALMOLOGY ─────────────────────────────────────
  Medicine(
    id: 'eye001', name: 'Timolol 0.5% Eye Drops', genericName: 'Timolol Maleate',
    brand: 'Glucomol', specialization: 'Ophthalmology', category: 'Glaucoma Treatment',
    dosageForm: 'Eye Drops', strength: '0.5%', pack: '5mL bottle',
    price: 55, mrp: 72, requiresRx: true, emoji: '👁️',
    description: 'Reduces intraocular pressure in glaucoma by decreasing aqueous humor production.',
    sideEffects: 'Eye irritation, systemic beta-blockade effects, blurred vision',
  ),
  Medicine(
    id: 'eye002', name: 'Ciprofloxacin 0.3% Eye Drops', genericName: 'Ciprofloxacin HCl',
    brand: 'Ciplox-D', specialization: 'Ophthalmology', category: 'Antibiotic Eye Drops',
    dosageForm: 'Eye Drops', strength: '0.3%', pack: '5mL bottle',
    price: 45, mrp: 58, requiresRx: true, emoji: '👁️',
    description: 'Treats bacterial eye infections including conjunctivitis and corneal ulcers.',
    sideEffects: 'Temporary burning/stinging, local irritation, white crystalline precipitate',
  ),
  Medicine(
    id: 'eye003', name: 'Carmellose 0.5% Eye Drops', genericName: 'Carboxymethylcellulose',
    brand: 'Refresh Tears', specialization: 'Ophthalmology', category: 'Lubricant Eye Drops',
    dosageForm: 'Eye Drops', strength: '0.5%', pack: '10mL bottle',
    price: 95, mrp: 125, requiresRx: false, emoji: '👁️',
    description: 'Artificial tears for dry eye syndrome. Lubricates and moisturizes the eye.',
    sideEffects: 'Temporary blurred vision immediately after use',
  ),

  // ── ENT ───────────────────────────────────────────────
  Medicine(
    id: 'e001', name: 'Cetirizine 10mg', genericName: 'Cetirizine HCl',
    brand: 'Zyrtec', specialization: 'ENT & Allergy', category: 'Antihistamine',
    dosageForm: 'Tablet', strength: '10mg', pack: 'Strip of 10',
    price: 28, mrp: 38, requiresRx: false, emoji: '🤧',
    description: 'Non-sedating antihistamine for allergic rhinitis, hives, and seasonal allergies.',
    sideEffects: 'Mild drowsiness, dry mouth, headache',
  ),
  Medicine(
    id: 'e002', name: 'Xylometazoline 0.1% Nasal Spray', genericName: 'Xylometazoline HCl',
    brand: 'Otrivin', specialization: 'ENT & Allergy', category: 'Nasal Decongestant',
    dosageForm: 'Nasal Spray', strength: '0.1%', pack: '10mL bottle',
    price: 115, mrp: 148, requiresRx: false, emoji: '👃',
    description: 'Fast nasal congestion relief from colds and sinusitis. Works within minutes.',
    sideEffects: 'Rebound congestion if used >3 days, burning sensation',
  ),
  Medicine(
    id: 'e003', name: 'Fluticasone Nasal Spray', genericName: 'Fluticasone Propionate',
    brand: 'Flomist', specialization: 'ENT & Allergy', category: 'Nasal Corticosteroid',
    dosageForm: 'Nasal Spray', strength: '50mcg/dose', pack: '150 doses',
    price: 185, mrp: 240, requiresRx: false, emoji: '👃',
    description: 'Long-term treatment of allergic rhinitis. Reduces nasal inflammation.',
    sideEffects: 'Nosebleeds, nasal dryness, headache',
  ),

  // ── UROLOGY ───────────────────────────────────────────
  Medicine(
    id: 'u001', name: 'Tamsulosin 0.4mg', genericName: 'Tamsulosin HCl',
    brand: 'Urimax', specialization: 'Urology', category: 'Alpha Blocker',
    dosageForm: 'Capsule', strength: '0.4mg', pack: 'Strip of 10',
    price: 95, mrp: 125, requiresRx: true, emoji: '💧',
    description: 'Relaxes muscles in prostate and bladder. Treats benign prostatic hyperplasia (BPH).',
    sideEffects: 'Dizziness, retrograde ejaculation, runny nose',
  ),
  Medicine(
    id: 'u002', name: 'Nitrofurantoin 100mg', genericName: 'Nitrofurantoin',
    brand: 'Macrobid', specialization: 'Urology', category: 'Urinary Antibiotic',
    dosageForm: 'Capsule', strength: '100mg', pack: 'Strip of 14',
    price: 145, mrp: 185, requiresRx: true, emoji: '💧',
    description: 'Antibiotic specifically for urinary tract infections (UTI). Concentrates in urine.',
    sideEffects: 'Urine turns brown/yellow, nausea, lung reactions rarely',
  ),

  // ── GYNECOLOGY / OBSTETRICS ───────────────────────────
  Medicine(
    id: 'gy001', name: 'Folic Acid 5mg', genericName: 'Folic Acid',
    brand: 'Folvite', specialization: 'Gynecology', category: 'Vitamin Supplement',
    dosageForm: 'Tablet', strength: '5mg', pack: 'Strip of 30',
    price: 22, mrp: 30, requiresRx: false, emoji: '🤰',
    description: 'Essential during pregnancy to prevent neural tube defects. Also treats anaemia.',
    sideEffects: 'Very rare — nausea, loss of appetite at high doses',
  ),
  Medicine(
    id: 'gy002', name: 'Progesterone 200mg', genericName: 'Micronized Progesterone',
    brand: 'Susten', specialization: 'Gynecology', category: 'Hormonal',
    dosageForm: 'Capsule', strength: '200mg', pack: 'Strip of 10',
    price: 185, mrp: 240, requiresRx: true, emoji: '🤰',
    description: 'Supports pregnancy and treats hormonal imbalances. Used in IVF protocols.',
    sideEffects: 'Drowsiness, breast tenderness, bloating, dizziness',
  ),
  Medicine(
    id: 'gy003', name: 'Iron + Folic Acid', genericName: 'Ferrous Sulphate + Folic Acid',
    brand: 'Feosol', specialization: 'Gynecology', category: 'Haematinic',
    dosageForm: 'Tablet', strength: '150mg + 1.5mg', pack: 'Strip of 30',
    price: 38, mrp: 50, requiresRx: false, emoji: '💊',
    description: 'Treats iron-deficiency anaemia. Essential supplement during pregnancy.',
    sideEffects: 'Black stools, constipation, stomach cramps, nausea',
  ),

  // ── PEDIATRICS ────────────────────────────────────────
  Medicine(
    id: 'pd001', name: 'Paracetamol Syrup 120mg/5mL', genericName: 'Paracetamol',
    brand: 'Calpol', specialization: 'Pediatrics', category: 'Analgesic/Antipyretic',
    dosageForm: 'Syrup', strength: '120mg/5mL', pack: '60mL bottle',
    price: 42, mrp: 55, requiresRx: false, emoji: '👶',
    description: 'Fever and mild pain relief for children 3 months and above.',
    sideEffects: 'Allergic reactions rarely, liver issues if overdosed',
  ),
  Medicine(
    id: 'pd002', name: 'Amoxicillin 125mg/5mL', genericName: 'Amoxicillin Trihydrate',
    brand: 'Mox', specialization: 'Pediatrics', category: 'Antibiotic',
    dosageForm: 'Syrup', strength: '125mg/5mL', pack: '60mL bottle',
    price: 65, mrp: 85, requiresRx: true, emoji: '👶',
    description: 'Broad-spectrum antibiotic for ear infections, throat infections, and pneumonia in children.',
    sideEffects: 'Diarrhea, rash, vomiting, yeast infections',
  ),
  Medicine(
    id: 'pd003', name: 'Ondansetron 4mg/5mL', genericName: 'Ondansetron HCl',
    brand: 'Vomikind', specialization: 'Pediatrics', category: 'Antiemetic',
    dosageForm: 'Syrup', strength: '4mg/5mL', pack: '30mL bottle',
    price: 55, mrp: 72, requiresRx: true, emoji: '👶',
    description: 'Treats nausea and vomiting in children from gastroenteritis or chemotherapy.',
    sideEffects: 'Constipation, headache, flushing',
  ),
  Medicine(
    id: 'pd004', name: 'Zinc 20mg Dispersible', genericName: 'Zinc Sulphate',
    brand: 'Zincovit', specialization: 'Pediatrics', category: 'Micronutrient',
    dosageForm: 'Tablet (Dispersible)', strength: '20mg', pack: 'Strip of 10',
    price: 28, mrp: 38, requiresRx: false, emoji: '👶',
    description: 'WHO recommended for diarrhea treatment in children. Reduces severity and duration.',
    sideEffects: 'Nausea, vomiting if taken on empty stomach',
  ),

  // ── ONCOLOGY (OTC Supportive) ─────────────────────────
  Medicine(
    id: 'on001', name: 'Ondansetron 8mg', genericName: 'Ondansetron HCl',
    brand: 'Zofran', specialization: 'Oncology', category: 'Chemotherapy Antiemetic',
    dosageForm: 'Tablet', strength: '8mg', pack: 'Strip of 10',
    price: 145, mrp: 185, requiresRx: true, emoji: '🎗️',
    description: 'Prevents chemotherapy and radiation-induced nausea and vomiting.',
    sideEffects: 'Constipation, headache, QT prolongation rarely',
  ),
  Medicine(
    id: 'on002', name: 'Megestrol 160mg', genericName: 'Megestrol Acetate',
    brand: 'Megace', specialization: 'Oncology', category: 'Appetite Stimulant',
    dosageForm: 'Tablet', strength: '160mg', pack: 'Strip of 10',
    price: 285, mrp: 370, requiresRx: true, emoji: '🎗️',
    description: 'Treats cancer-related weight loss and anorexia. Also for breast/endometrial cancer.',
    sideEffects: 'Fluid retention, weight gain, blood clots, adrenal insufficiency',
  ),

  // ── VITAMINS & SUPPLEMENTS ────────────────────────────
  Medicine(
    id: 'v001', name: 'Vitamin D3 60,000IU', genericName: 'Cholecalciferol',
    brand: 'D-Rise', specialization: 'Vitamins & Supplements', category: 'Vitamin D',
    dosageForm: 'Capsule', strength: '60,000 IU', pack: '4 capsules',
    price: 95, mrp: 125, requiresRx: false, emoji: '☀️',
    description: 'Weekly dose for vitamin D deficiency. Supports bone health and immune function.',
    sideEffects: 'Hypercalcemia if overused, nausea, weakness',
  ),
  Medicine(
    id: 'v002', name: 'Vitamin B12 1500mcg', genericName: 'Methylcobalamin',
    brand: 'Nervup', specialization: 'Vitamins & Supplements', category: 'Vitamin B12',
    dosageForm: 'Tablet', strength: '1500mcg', pack: 'Strip of 10',
    price: 65, mrp: 85, requiresRx: false, emoji: '💊',
    description: 'Treats vitamin B12 deficiency and peripheral neuropathy. Supports nerve health.',
    sideEffects: 'Very rare — mild diarrhea, itching',
  ),
  Medicine(
    id: 'v003', name: 'Omega-3 Fatty Acids 1000mg', genericName: 'Fish Oil EPA+DHA',
    brand: 'Maxepa', specialization: 'Vitamins & Supplements', category: 'Omega-3',
    dosageForm: 'Softgel', strength: '1000mg', pack: 'Strip of 10',
    price: 145, mrp: 185, requiresRx: false, emoji: '🐟',
    description: 'Reduces triglycerides and inflammation. Supports heart and brain health.',
    sideEffects: 'Fishy breath, stomach upset, increased bleeding risk',
  ),
  Medicine(
    id: 'v004', name: 'Multivitamin + Minerals', genericName: 'Multivitamin',
    brand: 'Supradyn', specialization: 'Vitamins & Supplements', category: 'Multivitamin',
    dosageForm: 'Tablet', strength: 'Complete formula', pack: 'Strip of 15',
    price: 165, mrp: 215, requiresRx: false, emoji: '💊',
    description: 'Daily supplement with all essential vitamins and minerals. Prevents deficiencies.',
    sideEffects: 'Harmless color change of urine, mild nausea',
  ),
  Medicine(
    id: 'v005', name: 'Iron Sucrose 100mg', genericName: 'Iron Sucrose',
    brand: 'Feronia', specialization: 'Vitamins & Supplements', category: 'Iron Supplement (IV)',
    dosageForm: 'Injection', strength: '100mg/5mL', pack: 'Single vial',
    price: 285, mrp: 365, requiresRx: true, emoji: '💉',
    description: 'IV iron for severe iron-deficiency anaemia when oral iron is not tolerated.',
    sideEffects: 'Hypotension, anaphylaxis rarely, injection site reactions',
  ),

  // ── ANTIBIOTICS ───────────────────────────────────────
  Medicine(
    id: 'ab001', name: 'Azithromycin 500mg', genericName: 'Azithromycin',
    brand: 'Azee', specialization: 'Antibiotics', category: 'Macrolide',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 3',
    price: 65, mrp: 85, requiresRx: true, emoji: '🦠',
    description: 'Z-pack antibiotic for respiratory, skin, and sexually transmitted infections.',
    sideEffects: 'Nausea, diarrhea, abdominal pain, QT prolongation',
  ),
  Medicine(
    id: 'ab002', name: 'Amoxicillin-Clavulanate 625mg', genericName: 'Co-Amoxiclav',
    brand: 'Augmentin', specialization: 'Antibiotics', category: 'Penicillin Combination',
    dosageForm: 'Tablet', strength: '500+125mg', pack: 'Strip of 6',
    price: 145, mrp: 185, requiresRx: true, emoji: '🦠',
    description: 'Broad-spectrum antibiotic for resistant infections. Covers many bacteria types.',
    sideEffects: 'Diarrhea, nausea, rash, yeast infections',
  ),
  Medicine(
    id: 'ab003', name: 'Ciprofloxacin 500mg', genericName: 'Ciprofloxacin HCl',
    brand: 'Ciplox', specialization: 'Antibiotics', category: 'Fluoroquinolone',
    dosageForm: 'Tablet', strength: '500mg', pack: 'Strip of 10',
    price: 55, mrp: 72, requiresRx: true, emoji: '🦠',
    description: 'Broad-spectrum antibiotic for UTIs, respiratory infections, and typhoid.',
    sideEffects: 'Tendon damage risk, nausea, photosensitivity, QT prolongation',
  ),
  Medicine(
    id: 'ab004', name: 'Doxycycline 100mg', genericName: 'Doxycycline Hyclate',
    brand: 'Doxt', specialization: 'Antibiotics', category: 'Tetracycline',
    dosageForm: 'Capsule', strength: '100mg', pack: 'Strip of 10',
    price: 42, mrp: 55, requiresRx: true, emoji: '🦠',
    description: 'Treats malaria, acne, chlamydia, and various bacterial infections.',
    sideEffects: 'Photosensitivity, esophageal irritation, GI upset',
  ),
];

// ═══════════════════════════════════════════════════════════
// MEDICINE SCREEN
// ═══════════════════════════════════════════════════════════

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedSpec = 'All';
  final Map<String, CartItem> _cart = {};

  static final List<String> _specializations = [
    'All', 'Cardiology', 'Diabetes', 'Gastroenterology',
    'Neurology', 'Respiratory', 'Dermatology', 'Psychiatry',
    'Orthopedics', 'Ophthalmology', 'ENT & Allergy', 'Urology',
    'Gynecology', 'Pediatrics', 'Oncology',
    'Vitamins & Supplements', 'Antibiotics',
  ];

  static const Map<String, String> _specEmojis = {
    'All': '💊', 'Cardiology': '❤️', 'Diabetes': '🩸',
    'Gastroenterology': '🫃', 'Neurology': '🧠', 'Respiratory': '🫁',
    'Dermatology': '🧴', 'Psychiatry': '🧘', 'Orthopedics': '🦴',
    'Ophthalmology': '👁️', 'ENT & Allergy': '🤧', 'Urology': '💧',
    'Gynecology': '🤰', 'Pediatrics': '👶', 'Oncology': '🎗️',
    'Vitamins & Supplements': '☀️', 'Antibiotics': '🦠',
  };

  List<Medicine> get _filtered {
    var list = allMedicines.toList();
    if (_selectedSpec != 'All') {
      list = list.where((m) => m.specialization == _selectedSpec).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.genericName.toLowerCase().contains(q) ||
          m.brand.toLowerCase().contains(q) ||
          m.category.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  int get _cartTotal => _cart.values
      .fold(0, (sum, item) => sum + (item.medicine.price * item.quantity));

  int get _cartCount =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);

  void _addToCart(Medicine m) {
    setState(() {
      if (_cart.containsKey(m.id)) {
        _cart[m.id]!.quantity++;
      } else {
        _cart[m.id] = CartItem(medicine: m);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _removeFromCart(String id) {
    setState(() {
      if (_cart[id] != null && _cart[id]!.quantity > 1) {
        _cart[id]!.quantity--;
      } else {
        _cart.remove(id);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Column(
        children: [
          _buildTopBar(),
          _buildSearchBar(),
          _buildSpecializationChips(),
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : _buildMedicineGrid(),
          ),
        ],
      ),
      floatingActionButton: _cartCount > 0
          ? FadeInUp(
              child: GestureDetector(
                onTap: () => _showCart(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.teal.withOpacity(0.4),
                          blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('$_cartCount items  ·  ₹$_cartTotal',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // ── Top Bar ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: AppColors.navyDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medicines',
                    style: TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text('All types by specialization',
                    style: TextStyle(color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          if (_cartCount > 0)
            GestureDetector(
              onTap: () => _showCart(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 20),
                  ),
                  Positioned(
                    top: -6, right: -6,
                    child: Container(
                      width: 20, height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.emergency, shape: BoxShape.circle),
                      child: Center(
                        child: Text('$_cartCount',
                            style: const TextStyle(color: Colors.white,
                                fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.navyDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.white.withOpacity(0.15), width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded,
                color: AppColors.textHint, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search medicine name, generic, brand…',
                  hintStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (_query.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textHint, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  // ── Specialization Chips ────────────────────────────
  Widget _buildSpecializationChips() {
    return Container(
      color: Colors.white,
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        itemCount: _specializations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final spec = _specializations[i];
          final isActive = spec == _selectedSpec;
          final count = spec == 'All'
              ? allMedicines.length
              : allMedicines
                  .where((m) => m.specialization == spec)
                  .length;
          return GestureDetector(
            onTap: () => setState(() => _selectedSpec = spec),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.blue : AppColors.bgPage,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isActive
                        ? AppColors.blue
                        : const Color(0xFFE3EAF2),
                    width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_specEmojis[spec] ?? '💊',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text('$spec ($count)',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : AppColors.navyLight)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Medicine Grid ───────────────────────────────────
  Widget _buildMedicineGrid() {
    final items = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: items.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: (i % 10) * 40),
        child: _MedicineCard(
          medicine: items[i],
          cartQty: _cart[items[i].id]?.quantity ?? 0,
          onAdd: () => _addToCart(items[i]),
          onRemove: () => _removeFromCart(items[i].id),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💊', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('No medicines found',
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Text('Try a different search or specialization',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── Cart Bottom Sheet ───────────────────────────────
  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scroll) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EAF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      const Text('Your Cart',
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$_cartCount items',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue)),
                      ),
                    ],
                  ),
                ),
                // Cart items
                Expanded(
                  child: _cart.isEmpty
                      ? const Center(
                          child: Text('Your cart is empty',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15)))
                      : ListView(
                          controller: scroll,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          children: _cart.values.map((item) =>
                              _CartItemTile(
                                item: item,
                                onAdd: () {
                                  _addToCart(item.medicine);
                                  setSheetState(() {});
                                },
                                onRemove: () {
                                  _removeFromCart(item.medicine.id);
                                  setSheetState(() {});
                                  if (_cart.isEmpty) Navigator.pop(ctx);
                                },
                              )).toList(),
                        ),
                ),
                // Bill summary + Pay
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Color(0xFFE3EAF2), width: 0.5)),
                  ),
                  child: Column(
                    children: [
                      _BillRow('Subtotal', '₹$_cartTotal'),
                      const SizedBox(height: 6),
                      _BillRow('Delivery', '₹49'),
                      const SizedBox(height: 6),
                      _BillRow(
                          'Discount',
                          '-₹${(_cartTotal * 0.05).round()}',
                          isGreen: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: Color(0xFFE3EAF2)),
                      ),
                      _BillRow(
                        'Total Payable',
                        '₹${_cartTotal + 49 - (_cartTotal * 0.05).round()}',
                        isBold: true,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showPayment();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            'Proceed to Pay  ₹${_cartTotal + 49 - (_cartTotal * 0.05).round()}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Payment Bottom Sheet ────────────────────────────
  void _showPayment() {
    final total =
        _cartTotal + 49 - (_cartTotal * 0.05).round();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(
        total: total,
        cartCount: _cartCount,
        onSuccess: () {
          setState(() => _cart.clear());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Order placed successfully! 🎉'),
                ],
              ),
              backgroundColor: AppColors.teal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// MEDICINE CARD
// ═══════════════════════════════════════════════════════════

class _MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final int cartQty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _MedicineCard({
    required this.medicine,
    required this.cartQty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cartQty > 0
              ? AppColors.teal.withOpacity(0.4)
              : const Color(0xFFE3EAF2),
          width: cartQty > 0 ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji icon
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(medicine.emoji,
                  style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(medicine.name,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(medicine.genericName,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary)),
                          Text(
                              '${medicine.brand} · ${medicine.dosageForm} · ${medicine.strength}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textHint)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Specialization badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(medicine.specialization,
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue)),
                    ),
                    const SizedBox(width: 5),
                    // Rx badge
                    if (medicine.requiresRx)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAEEDA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Rx',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF854F0B))),
                      ),
                    const Spacer(),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text('₹${medicine.price}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blue)),
                            const SizedBox(width: 5),
                            Text('₹${medicine.mrp}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textHint,
                                    decoration:
                                        TextDecoration.lineThrough)),
                          ],
                        ),
                        Text('${medicine.discount}% off · ${medicine.pack}',
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B6D11))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Add/Remove
                cartQty == 0
                    ? GestureDetector(
                        onTap: onAdd,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.blueLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text('+ Add to Cart',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blue)),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.bgPage,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xFFE3EAF2)),
                              ),
                              child: const Icon(Icons.remove_rounded,
                                  size: 16,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('$cartQty',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.teal)),
                            ),
                          ),
                          GestureDetector(
                            onTap: onAdd,
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.teal,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_rounded,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CART ITEM TILE
// ═══════════════════════════════════════════════════════════

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(item.medicine.emoji,
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.medicine.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(item.medicine.pack,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: const Color(0xFFE3EAF2)),
                  ),
                  child: const Icon(Icons.remove_rounded,
                      size: 14, color: AppColors.textPrimary),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${item.quantity}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text('₹${item.medicine.price * item.quantity}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BILL ROW
// ═══════════════════════════════════════════════════════════

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isGreen;

  const _BillRow(this.label, this.value,
      {this.isBold = false, this.isGreen = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isBold ? 14 : 13,
                fontWeight:
                    isBold ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.textSecondary)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                fontSize: isBold ? 16 : 13,
                fontWeight:
                    isBold ? FontWeight.w800 : FontWeight.w600,
                color: isGreen
                    ? const Color(0xFF3B6D11)
                    : isBold
                        ? AppColors.blue
                        : AppColors.textPrimary)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PAYMENT SHEET
// ═══════════════════════════════════════════════════════════

class _PaymentSheet extends StatefulWidget {
  final int total;
  final int cartCount;
  final VoidCallback onSuccess;

  const _PaymentSheet({
    required this.total,
    required this.cartCount,
    required this.onSuccess,
  });

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  String _selectedMethod = 'upi';
  bool _isProcessing = false;
  bool _success = false;
  final _upiCtrl = TextEditingController();

  static const _methods = [
    {'id': 'upi', 'label': 'UPI / GPay / PhonePe', 'icon': '📱'},
    {'id': 'card', 'label': 'Credit / Debit Card', 'icon': '💳'},
    {'id': 'netbanking', 'label': 'Net Banking', 'icon': '🏦'},
    {'id': 'cod', 'label': 'Cash on Delivery', 'icon': '💵'},
    {'id': 'ayurpay', 'label': 'AyurPay Wallet', 'icon': '🟢'},
  ];

  Future<void> _pay() async {
    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() { _isProcessing = false; _success = true; });
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    widget.onSuccess();
  }

  @override
  void dispose() {
    _upiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _success ? _buildSuccess() : _buildPaymentUI(),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Container(
              width: 90, height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3DE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.teal, size: 50),
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: const Text('Payment Successful!',
                style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Text(
              '${widget.cartCount} items ordered · Delivery in 2 hours',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentUI() {
    return Column(
      children: [
        // Handle + header
        Container(
          width: 40, height: 4,
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE3EAF2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              const Text('Payment',
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('₹${widget.total}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue)),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE3EAF2)),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Payment Method',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                ..._methods.map((m) => _buildMethodTile(m)),
                const SizedBox(height: 16),
                // UPI field
                if (_selectedMethod == 'upi')
                  FadeInDown(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('UPI ID',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _upiCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'yourname@ybl / @okaxis',
                            hintStyle: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13),
                            filled: true,
                            fillColor: AppColors.bgPage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE3EAF2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE3EAF2),
                                  width: 0.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // UPI apps row
                        Row(
                          children: [
                            _UpiApp('GPay', '🟢'),
                            const SizedBox(width: 10),
                            _UpiApp('PhonePe', '🟣'),
                            const SizedBox(width: 10),
                            _UpiApp('Paytm', '🔵'),
                            const SizedBox(width: 10),
                            _UpiApp('BHIM', '🇮🇳'),
                          ],
                        ),
                      ],
                    ),
                  ),
                // Security badge
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: Color(0xFF3B6D11), size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '256-bit SSL encrypted · RBI compliant · Ayur ID secured',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF3B6D11),
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Pay button
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 0, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _isProcessing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        ),
                        SizedBox(width: 12),
                        Text('Processing payment…',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ],
                    )
                  : Text('Pay ₹${widget.total}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodTile(Map<String, String> m) {
    final isSelected = _selectedMethod == m['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = m['id']!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueLight : AppColors.bgPage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.blue : const Color(0xFFE3EAF2),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(m['icon']!,
                style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(m['label']!,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.blue
                          : AppColors.textPrimary)),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.blue : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.blue : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpiApp extends StatelessWidget {
  final String name;
  final String emoji;

  const _UpiApp(this.name, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFE3EAF2), width: 0.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 3),
            Text(name,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
