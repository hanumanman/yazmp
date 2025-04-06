local M = {}

local function create_window(width, direction)
	vim.api.nvim_command("vsp")
	vim.api.nvim_command("wincmd " .. direction)
	pcall(vim.cmd, "buffer " .. M.buf)
	vim.api.nvim_win_set_width(0, width)
	vim.wo.winfixwidth = true
	vim.wo.cursorline = false
	vim.wo.winfixbuf = true
	vim.o.numberwidth = 1
	vim.wo.rnu = false
	vim.wo.nu = false
	-- Make buffer readonly
	vim.bo.readonly = true
	vim.bo.modifiable = false
end

function M.zenmode(c)
	if M.buf == nil then
		M.buf = vim.api.nvim_create_buf(false, false)
		local width = 30
		if #c.fargs == 1 then
			width = tonumber(c.fargs[1])
		end
		local cur_win = vim.fn.win_getid()
		create_window(width, "H")
		create_window(width, "L")
		vim.api.nvim_set_current_win(cur_win)

		-- Set up autocmd to close buffers on exit
		if not M.exit_autocmd_id then
			M.exit_autocmd_id = vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
						vim.api.nvim_buf_delete(M.buf, { force = true })
						M.buf = nil
					end
				end,
			})
		end
	else
		if M.exit_autocmd_id then
			vim.api.nvim_del_autocmd(M.exit_autocmd_id)
			M.exit_autocmd_id = nil
		end
		vim.api.nvim_buf_delete(M.buf, { force = true })
		M.buf = nil
	end
end

return M
