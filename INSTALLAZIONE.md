# Guida all'Installazione - PVP Assist

## Descrizione

PVP Assist è un addon per World of Warcraft che aiuta i giocatori a tracciare e massimizzare i loro punti Onore e Conquista in PVP. L'addon ti dice esattamente quali attività devi completare per raggiungere il cap massimo settimanale.

## Caratteristiche Principali

- ✅ **Tracciamento in Tempo Reale**: Monitora Onore e Conquista attuali
- ✅ **Cap Settimanale**: Vedi quanto hai guadagnato vs il cap settimanale
- ✅ **Raccomandazioni Intelligenti**: Suggerimenti prioritizzati per guadagnare punti
- ✅ **Quest Settimanali**: Traccia le quest PVP settimanali
- ✅ **Timer Reset**: Sapere esattamente quando avviene il reset settimanale
- ✅ **Facile Accesso**: Bottone minimappa e comandi slash

## Installazione

### Passo 1: Scaricare l'Addon

1. Scarica tutti i file dell'addon
2. Assicurati di avere questi file:
   - `PVPAssist.toc`
   - `Core.lua`
   - `UI.lua`

### Passo 2: Installare nella Directory Addons

**Windows:**
```
C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\PVP-ASSIST\
```

**Mac:**
```
/Applications/World of Warcraft/_retail_/Interface/AddOns/PVP-ASSIST/
```

### Passo 3: Avviare WoW

1. Riavvia World of Warcraft
2. Oppure usa il comando `/reload` in gioco

### Passo 4: Verificare l'Installazione

Quando entri in gioco, dovresti vedere:
```
PVP Assist loaded! Type /pvpassist to open the tracker.
```

## Come Usare l'Addon

### Aprire il Tracker

Puoi aprire il tracker in 3 modi:

1. **Bottone Minimappa**: Clicca l'icona della spada PVP vicino alla minimappa
2. **Comando Chat**: Digita `/pvpassist` nella chat
3. **Comando Corto**: Digita `/pvpa` nella chat

### Interfaccia

L'addon ti mostrerà:

#### 📊 Stato Attuale
- Onore totale e guadagno settimanale
- Conquista totale e guadagno settimanale
- Quanto ti manca per raggiungere il cap
- Tempo rimanente fino al reset settimanale

#### 🎯 Attività Raccomandate

**Per l'Onore:**
- Campi di Battaglia Casuali (~200-400 per vittoria)
- Campi di Battaglia Epici (~300-600 per vittoria)
- PVP nel Mondo / Modalità Guerra (ricompense variabili)

**Per la Conquista:**
- Campi di Battaglia Rated (~50-100 per vittoria)
- Arena 2v2/3v3 (~25-50 per vittoria)
- Solo Shuffle Rated (~30-60 per round)
- Rissa PVP Settimanale (bonus conquista)

#### ✓ Quest Settimanali
Traccia le quest PVP settimanali e il loro stato di completamento.

#### 💡 Suggerimenti
- Completa le quest giornaliere/settimanali per ricompense bonus
- Attiva Modalità Guerra per 10-30% bonus onore
- I contenuti rated danno ricompense conquista migliori
- Controlla il cercatore di gruppi per gruppi PVP attivi

## Comandi Disponibili

- `/pvpassist` - Apre/chiude la finestra del tracker
- `/pvpa` - Versione breve di /pvpassist

## Risoluzione Problemi

### L'addon non appare nella lista addon

1. Verifica che i file siano nella cartella corretta
2. Assicurati che il nome della cartella sia esattamente `PVP-ASSIST`
3. Riavvia completamente WoW

### Il bottone minimappa non appare

1. Prova a digitare `/pvpassist` per aprire la finestra
2. Il bottone dovrebbe apparire automaticamente
3. Verifica che non sia nascosto dietro altri elementi UI

### I dati non si aggiornano

1. Clicca il pulsante "Refresh" nella finestra
2. Guadagna un po' di onore/conquista per attivare l'aggiornamento
3. Usa `/reload` per ricaricare l'interfaccia

## Informazioni Tecniche

### ID Valuta
- Onore: 1792
- Conquista: 1602

### Compatibilità
- Progettato per WoW Retail (Dragonflight/The War Within)
- Versione Interfaccia: 110002

### Dati Salvati
L'addon salva dati minimi in `PVPAssistDB`:
- Informazioni di tracciamento settimanale
- Timestamp ultimo aggiornamento
- Attività tracciate

## Sviluppi Futuri

Possibili caratteristiche per versioni future:

1. **Integrazione API Wowhead**
   - Dati in tempo reale sui cap
   - Informazioni aggiornate sulle ricompense

2. **Tracciamento Storico**
   - Visualizza guadagni delle settimane precedenti
   - Statistiche stagionali

3. **Notifiche**
   - Avvisi quando sei vicino al cap
   - Promemoria per quest non completate

4. **Raccomandazioni Personalizzate**
   - Basate sul tuo rating PVP
   - Suggerimenti per migliorare l'equipaggiamento

## Supporto

Per bug o richieste di funzionalità:
- Apri una issue su GitHub
- Contatta ThePipSpi

## Crediti

**Autore**: ThePipSpi  
**Versione**: 1.0.0  
**Licenza**: Gratuito da usare e modificare

## Note sulla Privacy

Questo addon:
- ✅ Funziona solo in locale nel tuo client WoW
- ✅ Non invia dati a server esterni
- ✅ Non raccoglie informazioni personali
- ✅ Non usa API esterne (nella versione attuale)

Tutti i dati sono memorizzati localmente nel file SavedVariables di WoW.

---

**Buon farming di Onore e Conquista! 🗡️⚔️**
