/*
 * include/linux/sweep2wake.h
 *
 * Copyright (c) 2012, Dennis Rassmann <showp1984@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef _LINUX_SWEEP2WAKE_H
#define _LINUX_SWEEP2WAKE_H

#include <linux/input.h>
#include <linux/earlysuspend.h>
#include <linux/hrtimer.h>
#include <linux/input/lge_touch_core.h>

#define S2W_I2C_DELAY		20
#define S2W_I2C_MAX_COUNT	20

extern bool s2w_switch;
extern bool wake_from_s2w;
extern unsigned int retry_cnt;
extern bool scr_suspended;
extern bool scr_on_touch;
extern bool exec_count;
extern bool barrier[2];

/* Sweep2wake main function */
extern void detect_sweep2wake(int, int, struct lge_touch_data *ts);

/* PowerKey setter */
extern void sweep2wake_setdev(struct input_dev *);

#endif	/* _LINUX_SWEEP2WAKE_H */
