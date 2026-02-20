-- Mengambil status Git Branch secara aman untuk OS Windows
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	callback = function()
		-- Jalankan perintah git biasa
		local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
		
		-- Cek apakah tidak ada error dari eksekusi git
		if vim.v.shell_error == 0 and branch ~= "" then
			vim.b.git_branch = " Git:" .. branch .. " "
		else
			-- Jika bukan repo git, gunakan pesan yang ringkas
			vim.b.git_branch = " Git:none " 
			-- (Silakan ubah menjadi " Git:undefined " jika Anda lebih suka)
		end
	end
})

-- Fungsi untuk mengambil status device dari flutter-tools
local function get_flutter_device()
	local device = vim.g.flutter_tools_decorations and vim.g.flutter_tools_decorations.device
	if device and device ~= "" then
		return " | Dev:" .. device .. " "
	end
	return ""
end

-- Fungsi utama pembangun StatusLine
function _G.CustomStatusLine()
	-- Bagian Kiri: Nama File & Status Modified [+]
	local filepath = "%t"
	local modified = "%m"
	
	-- Bagian Kanan: Git Branch, Flutter Device, Persentase File, Baris:Kolom
	local git = vim.b.git_branch or " Git:none "
	local flutter = get_flutter_device()
	local position = " %p%% %l:%c "

	-- Gabungkan dengan pemisah %= (rata kanan)
	return " " .. filepath .. modified .. "%=" .. git .. flutter .. position
end

-- Terapkan ke Neovim
vim.o.statusline = "%!v:lua.CustomStatusLine()"
