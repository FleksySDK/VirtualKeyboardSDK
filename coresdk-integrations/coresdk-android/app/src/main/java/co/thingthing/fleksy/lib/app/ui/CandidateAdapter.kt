package co.thingthing.fleksy.lib.app.ui

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import co.thingthing.fleksy.lib.app.R
import co.thingthing.fleksy.lib.app.databinding.ItemCandidateBinding
import co.thingthing.fleksy.lib.model.Candidate

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

class CandidateAdapter(
    private val candidates: List<Candidate>,
    private val listener: (Candidate) -> Unit
) :
    RecyclerView.Adapter<CandidateAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val itemBinding =
            ItemCandidateBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(itemBinding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val candidate = candidates[position]
        holder.bind(candidate)
        holder.itemView.setOnClickListener { listener(candidate) }
    }

    class ViewHolder(private val binding: ItemCandidateBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bind(candidate: Candidate) {
            val rangeStart = candidate.replacements.minOfOrNull { it.start }.toString()
            val rangeEnd = candidate.replacements.maxOfOrNull { it.end }.toString()
            binding.tvLabel.text = candidate.label
            binding.tvCursor.text =
                binding.root.context.getString(R.string.range, rangeStart, rangeEnd)
            binding.tvType.text = candidate.type.toString().lowercase()
                .replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }
        }
    }

    override fun getItemCount(): Int =
        candidates.size

}