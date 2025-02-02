player.onChat("castle", function () {
    const wallBlock = Block.Stone; // Główne bloki 
    const windowBlock = Block.Glass; // Okna
    const floorBlock = Block.PlanksSpruce; // Podłoga 
    const roofBlock = Block.PlanksBirch; // Dach 
    const towerBlock = Block.StoneBricks; // Wieże

    // Wymiary zamku
    const castleWidth = 14; 
    const castleLength = 14;  
    const wallHeight = 6; 

    // Podłoga zamku
    blocks.fill(floorBlock, positions.create(0, 0, 0), positions.create(castleWidth - 1, 0, castleLength - 1));

    // Mury zamku
    // Przednia ściana z oknami i wejściem
    blocks.fill(wallBlock, positions.create(0, 1, 0), positions.create(castleWidth - 1, wallHeight, 0)); 
    blocks.fill(windowBlock, positions.create(4, 2, 0), positions.create(5, 3, 0)); // Lewe okno
    blocks.fill(windowBlock, positions.create(8, 2, 0), positions.create(9, 3, 0)); // Prawe okno
    blocks.fill(Block.Air, positions.create(6, 1, 0), positions.create(7, 3, 0)); // Wejście

    // Tylna ściana z oknami
    blocks.fill(wallBlock, positions.create(0, 1, castleLength - 1), positions.create(castleWidth - 1, wallHeight, castleLength - 1)); 
    blocks.fill(windowBlock, positions.create(4, 2, castleLength - 1), positions.create(5, 3, castleLength - 1)); // Lewe okno
    blocks.fill(windowBlock, positions.create(8, 2, castleLength - 1), positions.create(9, 3, castleLength - 1)); // Prawe okno

    // Lewa ściana z oknami
    blocks.fill(wallBlock, positions.create(0, 1, 0), positions.create(0, wallHeight, castleLength - 1)); 
    blocks.fill(windowBlock, positions.create(0, 2, 4), positions.create(0, 3, 5)); // Górne okno
    blocks.fill(windowBlock, positions.create(0, 2, 8), positions.create(0, 3, 9)); // Dolne okno

    // Prawa ściana z oknami
    blocks.fill(wallBlock, positions.create(castleWidth - 1, 1, 0), positions.create(castleWidth - 1, wallHeight, castleLength - 1)); 
    blocks.fill(windowBlock, positions.create(castleWidth - 1, 2, 4), positions.create(castleWidth - 1, 3, 5)); // Górne okno
    blocks.fill(windowBlock, positions.create(castleWidth - 1, 2, 8), positions.create(castleWidth - 1, 3, 9)); // Dolne okno

    // Wieże w rogach
    blocks.fill(towerBlock, positions.create(0, 0, 0), positions.create(2, wallHeight + 2, 2)); // Lewy przód
    blocks.fill(towerBlock, positions.create(castleWidth - 3, 0, 0), positions.create(castleWidth - 1, wallHeight + 2, 2)); // Prawy przód
    blocks.fill(towerBlock, positions.create(0, 0, castleLength - 3), positions.create(2, wallHeight + 2, castleLength - 1)); // Lewy tył
    blocks.fill(towerBlock, positions.create(castleWidth - 3, 0, castleLength - 3), positions.create(castleWidth - 1, wallHeight + 2, castleLength - 1)); // Prawy tył

    // Dach zamku 
    blocks.fill(roofBlock, positions.create(0, wallHeight + 1, 0), positions.create(castleWidth - 1, wallHeight + 1, castleLength - 1));

    // Blanki 
    for (let i = 0; i < castleWidth; i += 2) {
        blocks.place(wallBlock, positions.create(i, wallHeight + 2, 0)); // Przód
        blocks.place(wallBlock, positions.create(i, wallHeight + 2, castleLength - 1)); // Tył
    }
    for (let i = 0; i < castleLength; i += 2) {
        blocks.place(wallBlock, positions.create(0, wallHeight + 2, i)); // Lewa strona
        blocks.place(wallBlock, positions.create(castleWidth - 1, wallHeight + 2, i)); // Prawa strona
    }
});
