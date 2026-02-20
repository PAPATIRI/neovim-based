local terms = {}

local function toggle_term()
	-- Mengambil angka instance (default 1 jika hanya menekan Ctrl+/)
	local count = vim.v.count1
	local term = terms[count]

	-- Jika window terminal sedang terbuka, sembunyikan
	if term and vim.api.nvim_win_is_valid(term.win) then
		vim.api.nvim_win_hide(term.win)
		return
	end

	-- Konfigurasi ukuran dan posisi Floating Window
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	-- Jika buffer terminal belum ada, buat baru
	if not term or not vim.api.nvim_buf_is_valid(term.buf) then
		local buf = vim.api.nvim_create_buf(false, true)
		local win = vim.api.nvim_open_win(buf, true, opts)
		vim.fn.jobstart({ "powershell.exe", "-NoLogo" }, { term = true })
		terms[count] = { buf = buf, win = win }
	else
		-- Jika buffer sudah ada (tersembunyi), buka kembali windownya
		terms[count].win = vim.api.nvim_open_win(term.buf, true, opts)
	end

	-- Langsung masuk ke mode Insert saat terminal terbuka
	vim.cmd("startinsert")
end

-- Keymap untuk Normal Mode
vim.keymap.set("n", "<C-/>", toggle_term, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<C-_>", toggle_term, { desc = "Toggle Terminal (Fallback)" })

-- Keymap untuk Terminal Mode (menyembunyikan terminal)
vim.keymap.set("t", "<C-/>", "<C-\\><C-n>:hide<CR>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<C-_>", "<C-\\><C-n>:hide<CR>", { desc = "Hide Terminal" })
