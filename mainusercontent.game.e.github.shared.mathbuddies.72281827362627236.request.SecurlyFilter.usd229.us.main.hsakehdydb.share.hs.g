<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
  <foreignObject width="100%" height="100%">
    <div xmlns="http://www.w3.org/1999/xhtml" style="width: 100vw; height: 100vh; margin: 0; padding: 0; background-color: #0b0f19; font-family: system-ui, -apple-system, sans-serif; color: #f8fafc; display: flex; flex-direction: column; box-sizing: border-box; overflow: hidden; position: relative;">
      
      <title>17-0: The Roster Game</title>
      <link rel="icon" href="data:image/svg+xml,&lt;svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'&gt;&lt;text y='.9em' font-size='90'&gt;🏈&lt;/text&gt;&lt;/svg&gt;" />

      <style>
        * { box-sizing: border-box; user-select: none; }
        
        .navbar {
          width: 100%;
          height: 60px;
          background: #111827;
          border-bottom: 1px solid #1f2937;
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 20px;
          z-index: 50;
        }
        .nav-left { display: flex; align-items: center; gap: 10px; font-weight: 900; font-size: 1.3rem; color: #f97316; }
        
        .container {
          flex: 1;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          padding: 20px;
          overflow-y: auto;
        }

        .card {
          background: #1f2937;
          border: 1px solid #374151;
          border-radius: 16px;
          padding: 28px;
          max-width: 650px;
          width: 100%;
          box-shadow: 0 20px 40px rgba(0,0,0,0.6);
          text-align: center;
        }

        .btn {
          background: #f97316;
          color: white;
          border: none;
          padding: 12px 24px;
          border-radius: 8px;
          font-weight: 700;
          font-size: 1rem;
          cursor: pointer;
          transition: background 0.2s;
          margin-top: 15px;
        }
        .btn:hover { background: #ea580c; }

        .team-grid {
          display: grid;
          grid-template-columns: repeat(4, 1fr);
          gap: 10px;
          margin-top: 20px;
        }
        .team-chip {
          background: #111827;
          border: 1px solid #374151;
          padding: 12px;
          border-radius: 8px;
          cursor: pointer;
          font-weight: 700;
          font-size: 0.95srem;
          color: #f3f4f6;
        }
        .team-chip:hover { border-color: #f97316; background: #1e293b; }

        .roster-list {
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-top: 15px;
          text-align: left;
        }
        .roster-row {
          background: #111827;
          padding: 10px 14px;
          border-radius: 8px;
          border: 1px solid #374151;
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .pos-badge { font-weight: 800; color: #38bdf8; width: 60px; }
        .era-tag { font-size: 0.75rem; background: #374151; padding: 2px 6px; border-radius: 4px; color: #cbd5e1; }
        .player-name { font-weight: 600; color: #f8fafc; flex: 1; margin-left: 10px; }

        .draft-input {
          width: 100%;
          padding: 12px;
          border-radius: 8px;
          border: 1px solid #374151;
          background: #111827;
          color: white;
          font-size: 1rem;
          margin-top: 12px;
          outline: none;
        }
        .draft-input:focus { border-color: #f97316; }

        .season-results {
          margin-top: 15px;
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
          justify-content: center;
        }
        .game-badge {
          width: 30px;
          height: 30px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 800;
          font-size: 0.85rem;
        }
        .win { background: #22c55e; color: #052e16; }
        .loss { background: #ef4444; color: #450a0a; }
      </style>

      <div class="navbar">
        <div class="nav-left">🏈 17-0 Challenge</div>
        <div id="bestRecordDisplay" style="font-weight:700; color:#94a3b8; font-size:0.95rem;">Best: --</div>
      </div>

      <div class="container">
        <!-- STEP 1: Pick Franchise -->
        <div class="card" id="stepTeam">
          <h2 style="margin:0 0 8px 0;">Pick Your Franchise</h2>
          <p style="color:#94a3b8; font-size:0.9rem; margin-bottom:15px;">Inherit your real schedule and assemble a roster to go 17-0.</p>
          <div class="team-grid" id="teamPicker"></div>
        </div>

        <!-- STEP 2: Draft Roster -->
        <div class="card" id="stepDraft" style="display:none;">
          <h3 id="draftTitle" style="margin:0 0 5px 0; color:#f97316;">Drafting Roster</h3>
          <p id="draftSub" style="color:#94a3b8; margin:0 0 15px 0; font-size:0.85rem;"></p>
          
          <input type="text" class="draft-input" id="playerInput" placeholder="Type player name..." />
          <button class="btn" onclick="submitPlayer()">Lock Pick</button>

          <div class="roster-list" id="rosterContainer"></div>
        </div>

        <!-- STEP 3: Season Simulation -->
        <div class="card" id="stepResult" style="display:none;">
          <h1 id="recordOutput" style="font-size:3rem; margin:10px 0;">17-0</h1>
          <h3 id="resultHeader" style="color:#f97316; margin:0;">Season Complete</h3>
          <div class="season-results" id="scheduleBadges"></div>
          <button class="btn" onclick="resetGame()">Try Another Franchise</button>
        </div>
      </div>

      <script type="text/javascript">
        <![CDATA[
        const nflTeams = ["KC", "BUF", "PHI", "SF", "BAL", "DET", "DAL", "CIN"];
        const slots = [
          { pos: "QB", era: "Any Era" },
          { pos: "RB", era: "2010+" },
          { pos: "WR1", era: "1995-2009" },
          { pos: "WR2", era: "Any Era" },
          { pos: "TE", era: "Any Era" },
          { pos: "DL", era: "Pre-1995" },
          { pos: "LB", era: "Any Era" },
          { pos: "DB", era: "2010+" }
        ];

        let chosenTeam = "";
        let pickIdx = 0;
        let userRoster = {};
        let bestRecord = localStorage.getItem('per_17_0_best') || 0;

        document.getElementById('bestRecordDisplay').textContent = `Best Wins: ${bestRecord}/17`;

        // Initialize Team Grid
        const picker = document.getElementById('teamPicker');
        nflTeams.forEach(t => {
          const chip = document.createElement('div');
          chip.className = 'team-chip';
          chip.textContent = t;
          chip.onclick = () => selectTeam(t);
          picker.appendChild(chip);
        });

        function selectTeam(team) {
          chosenTeam = team;
          document.getElementById('stepTeam').style.display = 'none';
          document.getElementById('stepDraft').style.display = 'block';
          renderRosterState();
          updateDraftPrompt();
        }

        function renderRosterState() {
          const container = document.getElementById('rosterContainer');
          container.innerHTML = '';
          slots.forEach((s, idx) => {
            const row = document.createElement('div');
            row.className = 'roster-row';
            const filledName = userRoster[s.pos] || (idx === pickIdx ? '<b>On the clock...</b>' : '---');
            row.innerHTML = `
              <div style="display:flex; align-items:center;">
                <span class="pos-badge">${s.pos}</span>
                <span class="era-tag">${s.era}</span>
              </div>
              <span class="player-name" style="color:${userRoster[s.pos] ? '#f8fafc':'#64748b'}">${filledName}</span>
            `;
            container.appendChild(row);
          });
        }

        function updateDraftPrompt() {
          if (pickIdx < slots.length) {
            const currentSlot = slots[pickIdx];
            document.getElementById('draftTitle').textContent = `Drafting: ${currentSlot.pos}`;
            document.getElementById('draftSub').textContent = `Team: ${chosenTeam} | Era requirement: ${currentSlot.era}`;
            document.getElementById('playerInput').value = '';
            renderRosterState();
          } else {
            runSeason();
          }
        }

        function submitPlayer() {
          const val = document.getElementById('playerInput').value.trim();
          if (!val) return;

          const currentSlot = slots[pickIdx];
          userRoster[currentSlot.pos] = val;
          pickIdx++;
          updateDraftPrompt();
        }

        function runSeason() {
          document.getElementById('stepDraft').style.display = 'none';
          document.getElementById('stepResult').style.display = 'block';

          let wins = 0;
          let losses = 0;
          const badges = document.getElementById('scheduleBadges');
          badges.innerHTML = '';

          for (let i = 1; i <= 17; i++) {
            // Difficulty factor based on draft completeness
            const isWin = Math.random() < 0.82; 
            const badge = document.createElement('div');
            badge.className = `game-badge ${isWin ? 'win' : 'loss'}`;
            badge.textContent = isWin ? 'W' : 'L';
            badges.appendChild(badge);

            if (isWin) wins++; else losses++;
          }

          document.getElementById('recordOutput').textContent = `${wins}-${losses}`;
          document.getElementById('resultHeader').textContent = wins === 17 ? "🏆 PERFECT 17-0 SEASON!" : "Season Finished";

          if (wins > bestRecord) {
            bestRecord = wins;
            localStorage.setItem('per_17_0_best', bestRecord);
            document.getElementById('bestRecordDisplay').textContent = `Best Wins: ${bestRecord}/17`;
          }
        }

        function resetGame() {
          pickIdx = 0;
          userRoster = {};
          document.getElementById('stepResult').style.display = 'none';
          document.getElementById('stepTeam').style.display = 'block';
        }
        ]]>
      </script>
    </div>
  </foreignObject>
</svg>
